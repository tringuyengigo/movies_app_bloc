import 'package:movies_app_bloc/api/MediaApi.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/model/Actor.dart';
import 'package:movies_app_bloc/model/MediaFiltersIDType.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/model/TvSeason.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc implements BlocBase {
  //
  //Get actors
  //
  PublishSubject<MediaFiltersIDType> _castSubject = PublishSubject<MediaFiltersIDType>();
  Sink<MediaFiltersIDType> get inCastMedia => _castSubject.sink;
  Stream<MediaFiltersIDType> get outCastMedia => _castSubject.stream;

  PublishSubject<List<Actor>> _mediaCastController = PublishSubject<List<Actor>>();
  Sink<List<Actor>> get inCastMediaList => _mediaCastController.sink;
  Stream<List<Actor>> get outCastMediaList => _mediaCastController.stream;

  //
  //Get film detail
  //
  PublishSubject<MediaFiltersIDType> _detailSubject = PublishSubject<MediaFiltersIDType>();
  Sink<MediaFiltersIDType> get inDetailMedia => _detailSubject.sink;
  Stream<MediaFiltersIDType> get outDetailMedia => _detailSubject.stream;

  PublishSubject<dynamic> _mediaDetailController = PublishSubject<dynamic>();
  Sink<dynamic> get inDetailMediaList => _mediaDetailController.sink;
  Stream<dynamic> get outDetailMediaList => _mediaDetailController.stream;

  //
  //Get similar film
  //
  PublishSubject<MediaFiltersIDType> _similarSubject = PublishSubject<MediaFiltersIDType>();
  Sink<MediaFiltersIDType> get inSimilarMedia => _similarSubject.sink;
  Stream<MediaFiltersIDType> get outSimilarMedia => _similarSubject.stream;

  PublishSubject<List<MediaItem>> _mediaSimilarController = PublishSubject<List<MediaItem>>();
  Sink<List<MediaItem>> get inSimilarMediaList => _mediaSimilarController.sink;
  Stream<List<MediaItem>> get outSimilarMediaList => _mediaSimilarController.stream;

  //
  //Get film season
  //
  PublishSubject<MediaFiltersIDType> _seasonSubject = PublishSubject<MediaFiltersIDType>();
  Sink<MediaFiltersIDType> get inSeasonMedia => _seasonSubject.sink;
  Stream<MediaFiltersIDType> get outSeasonMedia => _seasonSubject.stream;

  PublishSubject<List<TvSeason>> _mediaSeasonController = PublishSubject<List<TvSeason>>();
  Sink<List<TvSeason>> get inSeasonMediaList => _mediaSeasonController.sink;
  Stream<List<TvSeason>> get outSeasonMediaList => _mediaSeasonController.stream;


  MovieDetailBloc() {
      outCastMedia.listen(_handleGetCast);
      outDetailMedia.listen(_handleGetDetails);
      outSimilarMedia.listen(_handleGetSimilar);
      outSeasonMedia.listen(_handleGetSeason);
  }

  void _handleGetCast(MediaFiltersIDType filter){
    print("MovieDetailBloc... _handleGetCast id = " + filter.id.toString() + " mediaType = " + filter.type);
    api.getMediaCredits(filter)
        .then((List<Actor> fetchedData) => _handleFetchedUpdateActorResult(fetchedData));
  }

  void _handleGetDetails(MediaFiltersIDType filter){
    print("MovieDetailBloc... _handleGetDetails id = " + filter.id.toString() + " mediaType = " + filter.type);
    api.getMediaDetails(filter)
        .then((dynamic fetchedData) => _handleFetchedUpdateDetailResult(fetchedData));
  }

  void _handleGetSimilar(MediaFiltersIDType filter){
    print("MovieDetailBloc... _handleGetDetails id = " + filter.id.toString() + " mediaType = " + filter.type);
    api.getSimilarMedia(filter)
        .then((List<MediaItem> fetchedData) => _handleFetchedUpdateSimilarResult(fetchedData));
  }

  void _handleGetSeason(MediaFiltersIDType filter){
    print("MovieDetailBloc... _handleGetSeason id = " + filter.id.toString() + " mediaType = " + filter.type);
    api.getShowSeasons(filter)
        .then((List<TvSeason> fetchedData) => _handleFetchedUpdateShowSeasonResult(fetchedData));
  }

  void _handleFetchedUpdateDetailResult(dynamic fetchedData) {
    inDetailMediaList.add(fetchedData);
  }

  void _handleFetchedUpdateActorResult(List<Actor> fetchedData) {
    inCastMediaList.add(fetchedData);
  }

  void _handleFetchedUpdateSimilarResult(List<MediaItem> fetchedData) {
    inSimilarMediaList.add(fetchedData);
  }

  void _handleFetchedUpdateShowSeasonResult(List<TvSeason> fetchedData) {
    inSeasonMediaList.add(fetchedData);
  }

  @override
  void dispose() {
    _castSubject.close();
    _mediaCastController.close();
    _detailSubject.close();
    _mediaDetailController.close();
    _similarSubject.close();
    _mediaSimilarController.close();
    _seasonSubject.close();
    _mediaSeasonController.close();
  }



}