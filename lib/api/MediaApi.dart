import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/util/utils.dart';
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
