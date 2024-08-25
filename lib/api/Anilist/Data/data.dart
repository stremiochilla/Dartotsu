import 'package:dantotsu/api/Anilist/Data/page.dart';
import 'package:dantotsu/api/Anilist/Data/user.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Anilist.dart';
import 'media.dart';

part 'Generated/data.g.dart';

void registerAllTypes() {
  TypeFactory.create<PageResponse>((json) => PageResponse.fromJson(json));
  TypeFactory.create<MediaResponse>((json) => MediaResponse.fromJson(json));
  TypeFactory.create<MediaListCollectionResponse>(
      (json) => MediaListCollectionResponse.fromJson(json));
  TypeFactory.create<ViewerResponse>((json) => ViewerResponse.fromJson(json));
  TypeFactory.create<UserListResponse>(
      (json) => UserListResponse.fromJson(json));
  TypeFactory.create<AnimeListResponse>(
      (json) => AnimeListResponse.fromJson(json));
  TypeFactory.create<MangaListResponse>(
      (json) => MangaListResponse.fromJson(json));
}

@JsonSerializable()
class UserListResponse {
  @JsonKey(name: 'data')
  final UserListData? data;

  UserListResponse({this.data});

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserListResponseToJson(this);
}

@JsonSerializable()
class UserListData {
  MediaListCollection? currentAnime;
  MediaListCollection? repeatingAnime;
  User? favoriteAnime;
  MediaListCollection? plannedAnime;
  MediaListCollection? currentManga;
  MediaListCollection? repeatingManga;
  User? favoriteManga;
  MediaListCollection? plannedManga;
  Page? recommendationQuery;
  MediaListCollection? recommendationPlannedQueryAnime;
  MediaListCollection? recommendationPlannedQueryManga;

  UserListData({
    this.currentAnime,
    this.repeatingAnime,
    this.favoriteAnime,
    this.plannedAnime,
    this.currentManga,
    this.repeatingManga,
    this.favoriteManga,
    this.plannedManga,
    this.recommendationQuery,
    this.recommendationPlannedQueryAnime,
    this.recommendationPlannedQueryManga,
  });

  factory UserListData.fromJson(Map<String, dynamic> json) =>
      _$UserListDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserListDataToJson(this);
}

@JsonSerializable()
class MediaResponse {
  @JsonKey(name: 'data')
  final MediaData? data;

  MediaResponse({this.data});

  factory MediaResponse.fromJson(Map<String, dynamic> json) =>
      _$MediaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MediaResponseToJson(this);
}

@JsonSerializable()
class MediaData {
  @JsonKey(name: 'Media')
  final Media? media;
  @JsonKey(name: 'Page')
  final Page? page;

  MediaData({this.media, this.page});

  factory MediaData.fromJson(Map<String, dynamic> json) =>
      _$MediaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDataToJson(this);
}

@JsonSerializable()
class MediaListCollectionResponse {
  @JsonKey(name: 'data')
  final MediaListCollectionData? data;

  MediaListCollectionResponse({this.data});

  factory MediaListCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$MediaListCollectionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MediaListCollectionResponseToJson(this);
}

@JsonSerializable()
class MediaListCollectionData {
  @JsonKey(name: 'MediaListCollection')
  final MediaListCollection? mediaListCollection;

  MediaListCollectionData({this.mediaListCollection});

  factory MediaListCollectionData.fromJson(Map<String, dynamic> json) =>
      _$MediaListCollectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaListCollectionDataToJson(this);
}

@JsonSerializable()
class ViewerResponse {
  @JsonKey(name: 'data')
  final ViewerData? data;

  ViewerResponse({this.data});

  factory ViewerResponse.fromJson(Map<String, dynamic> json) =>
      _$ViewerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ViewerResponseToJson(this);
}

@JsonSerializable()
class ViewerData {
  @JsonKey(name: 'Viewer')
  final User? user;

  ViewerData({this.user});

  factory ViewerData.fromJson(Map<String, dynamic> json) =>
      _$ViewerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ViewerDataToJson(this);
}

@JsonSerializable()
class AnimeListResponse {
  @JsonKey(name: 'data')
  final AnimeListData? data;

  AnimeListResponse({this.data});

  factory AnimeListResponse.fromJson(Map<String, dynamic> json) =>
      _$AnimeListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeListResponseToJson(this);
}

@JsonSerializable()
class AnimeListData {
  Page? recentUpdates;
  Page? trendingMovies;
  Page? topRatedSeries;
  Page? mostFavSeries;

  AnimeListData({
    this.recentUpdates,
    this.trendingMovies,
    this.topRatedSeries,
    this.mostFavSeries,
  });

  factory AnimeListData.fromJson(Map<String, dynamic> json) =>
      _$AnimeListDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeListDataToJson(this);
}

@JsonSerializable()
class MangaListResponse {
  @JsonKey(name: 'data')
  final MangaListData? data;

  MangaListResponse({this.data});

  factory MangaListResponse.fromJson(Map<String, dynamic> json) =>
      _$MangaListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MangaListResponseToJson(this);
}

@JsonSerializable()
class MangaListData {
  Page? trendingManga;
  Page? trendingManhwa;
  Page? trendingNovel;
  Page? topRated;
  Page? mostFav;

  MangaListData({
    this.trendingManga,
    this.trendingManhwa,
    this.trendingNovel,
    this.topRated,
    this.mostFav,
  });

  factory MangaListData.fromJson(Map<String, dynamic> json) =>
      _$MangaListDataFromJson(json);

  Map<String, dynamic> toJson() => _$MangaListDataToJson(this);
}

@JsonSerializable()
class PageResponse {
  @JsonKey(name: 'data')
  final MediaData? data;

  PageResponse({this.data});

  factory PageResponse.fromJson(Map<String, dynamic> json) =>
      _$PageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PageResponseToJson(this);
}

@JsonSerializable()
class PageData {
  @JsonKey(name: 'Page')
  final Page? page;

  PageData({this.page});

  factory PageData.fromJson(Map<String, dynamic> json) =>
      _$PageDataFromJson(json);

  Map<String, dynamic> toJson() => _$PageDataToJson(this);
}
