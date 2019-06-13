import 'dart:async';

import 'package:collection/collection.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/model/MediaFilters.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movies_app_bloc/api/MediaApi.dart';

class MovieBloc implements BlocBase {
  List<MediaItem> movies = [];
  ///
  /// We also want to handle changes to the filters
  ///
  BehaviorSubject<MediaFilters> _filtersController = BehaviorSubject<MediaFilters>(seedValue: MediaFilters( 1,  mediaTypeMain,  "popular"));

  static String mediaTypeMain;

  MediaFilters filter;
  Sink<MediaFilters> get inFilters => _filtersController.sink;
  Stream<MediaFilters> get outFilters => _filtersController.stream;

  ///
  /// We are going to need the list of movies to be displayed
  ///
  PublishSubject<List<MediaItem>> _moviesController = PublishSubject<List<MediaItem>>();
  Sink<List<MediaItem>> get _inMoviesList => _moviesController.sink;
  Stream<List<MediaItem>> get outMoviesList => _moviesController.stream;

  ///
  /// Constructor
  ///
  MovieBloc(MediaType mediaType, String category) {
    if(mediaType.index == 0) {
      mediaTypeMain = "movie";
    } else {
      mediaTypeMain = "tv";
    }
    MediaFilters filter = MediaFilters(1, mediaTypeMain, category);
    inFilters.add(filter);
    outFilters.listen(_handleLoadMedia);
  }
  
  void _handleFetchedUpdateMoviesList(List<MediaItem> data) {
    movies.addAll(data);
    print("_handleFetchedUpdateMoviesList..." + movies.length.toString());
    _inMoviesList.add(UnmodifiableListView<MediaItem>(movies));
  }


  ///
  /// We want to set new filters
  ///
  void _handleLoadMedia(MediaFilters mediaFilters){
    // First, let's record the new filter information
    print("_handleLoadMedia..." + mediaFilters.page.toString());
    api.loadMedia(mediaFilters.page, mediaFilters.category, mediaFilters.type)
        .then((List<MediaItem> fetchedData) => _handleFetchedUpdateMoviesList(fetchedData));
  }

  @override
  void dispose() {
    _filtersController.close();
    _moviesController.close();
  }
}
