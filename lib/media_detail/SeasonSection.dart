import 'package:flutter/material.dart';
import 'package:movies_app_bloc/media_detail/SeasonCard.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/model/TvSeason.dart';


class SeasonSection extends StatelessWidget {
  final MediaItem _show;
  final List<TvSeason> _seasons;

  SeasonSection(this._show, this._seasons);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Seasons",
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 8.0,
        ),
        Container(
          height: 140.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _seasons
                .map((TvSeason season) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SeasonCard(_show, season),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
