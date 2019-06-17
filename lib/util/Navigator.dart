import 'package:flutter/material.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/screens/MediaDetailScreen.dart';
import 'package:movies_app_bloc/screens/SearchScreen.dart';

goToMovieDetails(BuildContext context, MediaItem movie, String mediaType) {
  _pushWidgetWithFade(context, MediaDetailScreen(movie, mediaType));
}
//
//goToSeasonDetails(BuildContext context, MediaItem show, TvSeason season) =>
//    _pushWidgetWithFade(context, SeasonDetailScreen(show, season));
//
//goToActorDetails(BuildContext context, Actor actor) {
//  _pushWidgetWithFade(context, ActorDetailScreen(actor));
//}

goToSearch(BuildContext context) {
  _pushWidgetWithFade(context, SearchScreen());
}

//goToFavorites(BuildContext context) {
//  _pushWidgetWithFade(context, FavoriteScreen());
//}

_pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push(
        PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
            pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
              return widget;
            }),
      );
}
