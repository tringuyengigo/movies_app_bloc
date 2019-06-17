import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:movies_app_bloc/model/Actor.dart';
import 'package:movies_app_bloc/model/MediaFiltersIDType.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/model/SearchResult.dart';
import 'package:movies_app_bloc/model/TvSeason.dart';
import 'package:movies_app_bloc/util/Utils.dart';
import 'package:http/http.dart';
///
/// MEDIA API
/// 
/// To get an API key, it is FREE => go to "https://www.themoviedb.org/"
/// 

class MediaApi {
  var client = Client();
  final _http = HttpClient();

  Future<dynamic> _getJson(Uri uri) async {
    var response = await (await _http.getUrl(uri)).close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    print("[MediaApi]_getJson response " + response.toString());
    print("[MediaApi]_getJson transformedResponse " + transformedResponse);
    return json.decode(transformedResponse);
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    var url = Uri
        .https(baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});

    return _getJson(url).then((json) => json['results']
        .map<SearchResult>((item) => SearchResult.fromJson(item))
        .toList());
  }

  Future<List<Actor>> getMediaCredits(MediaFiltersIDType filter) async {
    String mediaType = filter.type;
    String mediaID = filter.id.toString();
    var url =
    Uri.https(baseUrl, '3/$mediaType/$mediaID/credits', {'api_key': API_KEY});

    return _getJson(url).then((json) =>
        json['cast'].map<Actor>((item) => Actor.fromJson(item)).toList());
  }

  Future<dynamic> getMediaDetails(MediaFiltersIDType filter) async {
    String mediaType = filter.type;
    String mediaID = filter.id.toString();
    var url = Uri.https(baseUrl, '3/$mediaType/$mediaID', {'api_key': API_KEY});

    return _getJson(url);
  }

  Future<List<MediaItem>> getSimilarMedia(MediaFiltersIDType filter) async {
    String mediaType = filter.type;
    String mediaID = filter.id.toString();
    var url = Uri.https(baseUrl, '3/$mediaType/$mediaID/similar', {
      'api_key': API_KEY,
    });

    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(
        item, (mediaType == "movie") ? MediaType.movie : MediaType.show))
        .toList());
  }

  Future<List<TvSeason>> getShowSeasons(MediaFiltersIDType filter) async {
    var detailJson = await getMediaDetails(filter);
    return detailJson['seasons']
        .map<TvSeason>((item) => TvSeason.fromMap(item))
        .toList();
  }

  Future<List<MediaItem>> loadMedia(int page, String category, String typeMedia) async {
    var url = Uri.https(baseUrl, '3/$typeMedia/$category',
        {'api_key': API_KEY, 'page': page.toString()});
    print("[MediaApi] Link load loadMovies " + url.toString());
    if(typeMedia == "movie") {
      return _getJson(url).then((json) => json['results']).then((data) => data
          .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
          .toList());
    } else {
      return _getJson(url).then((json) => json['results']).then((data) => data
          .map<MediaItem>((item) => MediaItem(item, MediaType.show))
          .toList());
    }
  }

}
MediaApi api = MediaApi();
