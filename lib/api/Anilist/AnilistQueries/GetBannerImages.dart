part of '../AnilistQueries.dart';

extension GetBannerImages on AnilistQueries {
  Future<List<String?>> _getBannerImages() async {
    final b = <String?>[null, null];
    b[0] = await _bannerImage("ANIME");
    b[1] = await _bannerImage("MANGA");
    return b;
  }

  Future<String?> _bannerImage(String type) async {
    var url = PrefManager.getCustomVal<String>("banner_${type}_url");
    var time = PrefManager.getCustomVal<int>("banner_${type}_time");
    bool checkTime() {
      if (time == null) return true;
      return DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(time))
          .inDays >
          1;
    }

    if (url == null || url.isEmpty || checkTime()) {
      final response = await executeQuery<MediaListCollectionResponse>(_queryBanner(type));
      final bannerImages = response?.data?.mediaListCollection?.lists
          ?.expand((list) => list.entries ?? [])
          .map((entry) => entry.media?.bannerImage)
          .where((imageUrl) => imageUrl != null && imageUrl != 'null')
          .toList() ??
          [];
      bannerImages.shuffle(Random());
      var random = bannerImages.isNotEmpty ? bannerImages.first : null;

      PrefManager.setCustomVal("banner_${type}_url", random);
      PrefManager.setCustomVal(
          "banner_${type}_time", DateTime.now().millisecondsSinceEpoch);

      return random;
    } else {
      return url;
    }
  }
}

String _queryBanner(String type)=> '''{
  MediaListCollection(
    userId: ${Anilist.userid}, 
    type: $type, 
    chunk: 1, 
    perChunk: 25, 
    sort: [SCORE_DESC, UPDATED_TIME_DESC]
  ) { 
    lists { 
      entries { 
        media { 
          id 
          bannerImage 
        } 
      } 
    } 
  } 
}
''';

