import 'package:flutter/material.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/scoped_models/AppModel.dart';
import 'package:movies_app_bloc/utilviews/ToggleThemeWidget.dart';
import 'package:scoped_model/scoped_model.dart';

import 'MediaListItemActors.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Favorites"),
          actions: <Widget>[ToggleThemeButton()],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
              ),
              Tab(
                icon: Icon(Icons.tv),
              ),
            ],
          ),
        ),
        body: ScopedModelDescendant<AppModel>(
          builder: (context, child, AppModel model) => TabBarView(
                children: <Widget>[
                  _FavoriteList(model.favoriteMovies, "movies"),
                  _FavoriteList(model.favoriteShows, "shows"),
                ],
              ),
        ),
      ),
    );
  }
}

class _FavoriteList extends StatelessWidget {
  final List<MediaItem> _media;
  final String typeMedia;

  const _FavoriteList(this._media, this.typeMedia, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _media.length == 0
        ? Center(child: Text("You have no favorites yet!"))
        : ListView.builder(
            itemCount: _media.length,
            itemBuilder: (BuildContext context, int index) {
              return MediaListItemActors(_media[index], typeMedia);
            });
  }
}
