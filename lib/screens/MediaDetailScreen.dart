import 'dart:math';
import 'package:flutter/material.dart';
import 'package:movies_app_bloc/blocs/MovieDetailBloc.dart';
import 'package:movies_app_bloc/media_detail/CastSection.dart';
import 'package:movies_app_bloc/media_detail/MetaSection.dart';
import 'package:movies_app_bloc/media_detail/SeasonSection.dart';
import 'package:movies_app_bloc/media_detail/SimilarSection.dart';
import 'package:movies_app_bloc/model/Actor.dart';
import 'package:movies_app_bloc/model/MediaFiltersIDType.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/model/TvSeason.dart';
import 'package:movies_app_bloc/scoped_models/AppModel.dart';
import 'package:movies_app_bloc/util/Styles.dart';
import 'package:movies_app_bloc/util/Utils.dart';
import 'package:movies_app_bloc/utilviews/BottomGradient.dart';
import 'package:movies_app_bloc/utilviews/TextBubble.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaDetailScreen extends StatefulWidget {
  final MediaItem mediaItem;
  final String typeMedia;
  MediaDetailScreen(this.mediaItem, this.typeMedia);

  @override
  MediaDetailScreenState createState() {
    return MediaDetailScreenState();
  }

}

class MediaDetailScreenState extends State<MediaDetailScreen> {
  bool _visible = false;
  List<TvSeason> _seasonList;
  MovieDetailBloc movieDetailBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primary,
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(widget.mediaItem),
            _buildContentSection(widget.mediaItem),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _createBloc();

  }

  void _createBloc() {
    MediaFiltersIDType filter = MediaFiltersIDType(widget.mediaItem.id, widget.typeMedia);
      movieDetailBloc = MovieDetailBloc();
      movieDetailBloc.inCastMedia.add(filter);
      movieDetailBloc.inDetailMedia.add(filter);
      movieDetailBloc.inSimilarMedia.add(filter);
      movieDetailBloc.inSeasonMedia.add(filter);
  }

  Widget _buildAppBar(MediaItem movie) {
    return SliverAppBar(
      expandedHeight: 240.0,
      pinned: true,
      actions: <Widget>[
        ScopedModelDescendant<AppModel>(
            builder: (context, child, AppModel model) => IconButton(
                icon: Icon(model.isItemFavorite(widget.mediaItem)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => model.toggleFavorites(widget.mediaItem)))
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: "Movie-Tag-${widget.mediaItem.id}",
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: "assets/placeholder.jpg",
                  image: widget.mediaItem.getBackDropUrl()),
            ),
            BottomGradient(),
            _buildMetaSection(movie)
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(mediaItem.voteAverage.toString(),
                    backgroundColor: Color(0xffF47663)),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(mediaItem.title,
                  style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20.0)),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((genre) => Row(
                children: <Widget>[
                  TextBubble(genre),
                  Container(
                    width: 8.0,
                  )
                ],
              )).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {

    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(color: const Color(0xff222128)),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SYNOPSIS",
                  style: const TextStyle(color: Colors.white),
                ),
                Container(
                  height: 8.0,
                ),
                Text(media.overview,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 12.0)),
                Container(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primary),
          child:  StreamBuilder<List<Actor>>(
              stream: movieDetailBloc.outCastMediaList,
              builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
                if(snapshot.data == null) {
                  return Center( child: CircularProgressIndicator(),);
                } else { return CastSection(snapshot.data);}
              }
          ),
        ),
        Container(
          decoration: BoxDecoration(color: primaryDark),
          padding: const EdgeInsets.all(16.0),
          child:  StreamBuilder<dynamic>(
            stream: movieDetailBloc.outDetailMediaList,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.data == null) {
                return Center(child: CircularProgressIndicator(),);
              } else {return MetaSection(snapshot.data);}
            }
          ),
        ),
        (widget.mediaItem.type == MediaType.show)
            ? Container(
          decoration: BoxDecoration(color: primary),
          child:  StreamBuilder<List<TvSeason>>(
              stream: movieDetailBloc.outSeasonMediaList,
              builder: (BuildContext context, AsyncSnapshot<List<TvSeason>> snapshot) {
                if(snapshot.data == null) {
                  return Center(child: CircularProgressIndicator(),);
                } else {return SeasonSection(widget.mediaItem, snapshot.data);}
              }
          ),
        )
            : Container(),
        Container(
            decoration: BoxDecoration(
                color: (widget.mediaItem.type == MediaType.movie
                    ? primary
                    : primaryDark)),
            child:  StreamBuilder<List<MediaItem>>(
                stream: movieDetailBloc.outSimilarMediaList,
                builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
                  if(snapshot.data == null) {
                    return Center(child: CircularProgressIndicator(),);
                  } else {return SimilarSection(snapshot.data);}
                }
            ),
        ),
      ]),
    );
  }

}