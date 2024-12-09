import 'package:dantotsu/Services/Screens/BaseHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../Adaptor/Media/Widgets/MediaSection.dart';
import '../../../DataClass/Media.dart';
import '../../../DataClass/MediaSection.dart';
import '../../../DataClass/User.dart';
import '../../../Functions/Function.dart';
import '../../../Preferences/PrefManager.dart';
import '../../../Preferences/Preferences.dart';
import '../../../Widgets/CustomElevatedButton.dart';
import '../../../main.dart';
import '../Anilist.dart';

class AnilistHomeScreen extends BaseHomeScreen {
  final AnilistController Anilist;

  AnilistHomeScreen(this.Anilist);

  var animeContinue = Rx<List<Media>?>(null);
  var animeFav = Rx<List<Media>?>(null);
  var animePlanned = Rx<List<Media>?>(null);
  var mangaContinue = Rx<List<Media>?>(null);
  var mangaFav = Rx<List<Media>?>(null);
  var mangaPlanned = Rx<List<Media>?>(null);
  var recommendation = Rx<List<Media>?>(null);
  var userStatus = Rx<List<userData>?>(null);
  var hidden = Rx<List<Media>?>(null);

  @override
  get paging => false;

  Future<void> getUserId() async {
    if (Anilist.token.isNotEmpty) {
      await Anilist.query!.getUserData();
    }
  }

  @override
  Future<void> loadAll() async {
    await getUserId();
    await Future.wait([
      loadList(),
      setListImages(),
    ]);
  }

  Future<void> setListImages() async {
    listImages.value = await Anilist.query!.getBannerImages();
  }

  Future<void> loadList() async {
    resetPageData();
    final res = await Anilist.query!.initHomePage();
    _setMediaList(res!);
  }

  void _setMediaList(Map<String, List<Media>> res) {
    animeContinue.value = res["currentAnime"] ?? [];
    animeFav.value = res["favoriteAnime"] ?? [];
    animePlanned.value = res["currentAnimePlanned"] ?? [];
    mangaContinue.value = res["currentManga"] ?? [];
    mangaFav.value = res["favoriteManga"] ?? [];
    mangaPlanned.value = res["currentMangaPlanned"] ?? [];
    recommendation.value = res["recommendations"] ?? [];
    hidden.value = res["hidden"] ?? [];
  }

  @override
  int get refreshID => RefreshId.Anilist.homePage;

  @override
  void resetPageData() {
    animeContinue.value = null;
    animeFav.value = null;
    animePlanned.value = null;
    mangaContinue.value = null;
    mangaFav.value = null;
    mangaPlanned.value = null;
    recommendation.value = null;
    hidden.value = null;
  }

  @override
  List<Widget> mediaContent(BuildContext context) {
    var showHidden = false.obs;

    final mediaSections = [
      MediaSectionData(
        type: 0,
        title: 'Continue Watching',
        list: animeContinue.value,
        emptyIcon: Icons.movie_filter_rounded,
        emptyMessage: 'All caught up, when New?',
        emptyButtonText: 'Browse\nAnime',
        emptyButtonOnPressed: () => navbar?.onClick(0),
        onLongPressTitle: () => showHidden.value = !showHidden.value,
      ),
      MediaSectionData(
        type: 0,
        title: 'Favourite Anime',
        list: animeFav.value,
        emptyIcon: Icons.heart_broken,
        emptyMessage:
            'Looks like you don\'t like anything,\nTry liking a show to keep it here.',
      ),
      MediaSectionData(
        type: 0,
        title: 'Planned Anime',
        list: animePlanned.value,
        emptyIcon: Icons.movie_filter_rounded,
        emptyMessage: 'All caught up, when New?',
        emptyButtonText: 'Browse\nAnime',
        emptyButtonOnPressed: () => navbar?.onClick(0),
      ),
      MediaSectionData(
        type: 0,
        title: 'Continue Reading',
        list: mangaContinue.value,
        emptyIcon: Icons.import_contacts,
        emptyMessage: 'All caught up, when New?',
        emptyButtonText: 'Browse\nManga',
        emptyButtonOnPressed: () => navbar?.onClick(2),
      ),
      MediaSectionData(
        type: 0,
        title: 'Favourite Manga',
        list: mangaFav.value,
        emptyIcon: Icons.heart_broken,
        emptyMessage:
            'Looks like you don\'t like anything,\nTry liking a show to keep it here.',
      ),
      MediaSectionData(
        type: 0,
        title: 'Planned Manga',
        list: mangaPlanned.value,
        emptyIcon: Icons.import_contacts,
        emptyMessage: 'All caught up, when New?',
        emptyButtonText: 'Browse\nManga',
        emptyButtonOnPressed: () => navbar?.onClick(2),
      ),
      MediaSectionData(
        type: 0,
        title: 'Recommended',
        list: recommendation.value,
        emptyIcon: Icons.auto_awesome,
        isLarge: true,
        emptyMessage: 'Watch/Read some Anime or Manga to get Recommendations',
      ),
    ];

    final homeLayoutMap = PrefManager.getVal(PrefName.anilistHomeLayout);
    final sectionMap = {
      for (var section in mediaSections) section.title: section
    };
    final sectionWidgets = homeLayoutMap.entries
        .where((entry) => entry.value)
        .map((entry) => sectionMap[entry.key])
        .whereType<MediaSectionData>()
        .map((section) => MediaSection(
              context: context,
              type: section.type,
              title: section.title,
              mediaList: section.list,
              isLarge: section.isLarge,
              onLongPressTitle: section.onLongPressTitle,
              customNullListIndicator: _buildNullIndicator(
                context,
                section.emptyIcon,
                section.emptyMessage,
                section.emptyButtonText,
                section.emptyButtonOnPressed,
              ),
            ))
        .toList()
      ..add(const SizedBox(height: 128));

    var hiddenMedia = MediaSection(
      context: context,
      type: 0,
      title: 'Hidden Media',
      mediaList: hidden.value,
      onLongPressTitle: () => showHidden.value = !showHidden.value,
      customNullListIndicator: _buildNullIndicator(
        context,
        Icons.visibility_off,
        'No hidden media found',
        null,
        null,
      ),
    );

    return [
      Obx(() {
        if (showHidden.value) {
          sectionWidgets.insert(0, hiddenMedia);
        } else {
          sectionWidgets.remove(hiddenMedia);
        }
        return Column(
          children: sectionWidgets,
        );
      }),
    ];
  }

  List<Widget> _buildNullIndicator(BuildContext context, IconData? icon,
      String? message, String? buttonLabel, void Function()? onPressed) {
    var theme = Theme.of(context).colorScheme;

    return [
      Icon(
        icon,
        color: theme.onSurface.withOpacity(0.58),
        size: 32,
      ),
      Text(
        message ?? '',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: theme.onSurface.withOpacity(0.58),
        ),
      ),
      if (buttonLabel != null) ...[
        const SizedBox(height: 24.0),
        CustomElevatedButton(
          context: context,
          onPressed: onPressed,
          label: buttonLabel,
        ),
      ]
    ];
  }
}
