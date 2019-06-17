import 'package:collection/collection.dart';
import 'package:movies_app_bloc/api/MediaApi.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/model/MediaFilters.dart';
import 'package:movies_app_bloc/model/SearchResult.dart';
import 'package:movies_app_bloc/util/Utils.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc implements BlocBase {

  int currentState = -1;

  PublishSubject<String> _querySubject = PublishSubject<String>();
  Sink<String> get inSearchMovie => _querySubject.sink;
  Stream<String> get outSearchMovie => _querySubject.stream;

  PublishSubject<List<SearchResult>> _mediaSearchController = PublishSubject<List<SearchResult>>();
  Sink<List<SearchResult>> get inSearchMediaList => _mediaSearchController.sink;
  Stream<List<SearchResult>> get outSearchMediaList => _mediaSearchController.stream;
  ///
  /// Constructor
  ///
  SearchBloc(String query) {
    print("SearchBloc...Constructor " + query);
    outSearchMovie.listen(_handleSearchMedia);
  }


  void _handleSearchMedia(String query){
    print("SearchBloc... _handleSearchMedia" + query);
    api.getSearchResults(query)
        .then((List<SearchResult> fetchedData) => _handleFetchedUpdateSearchResult(fetchedData));
  }

  void _handleFetchedUpdateSearchResult(List<SearchResult> data) {
    print("_handleFetchedUpdateMoviesList..." + data.length.toString());
    inSearchMediaList.add(data);
  }

  @override
  void dispose() {
    _querySubject.close();
    _mediaSearchController.close();
  }

}