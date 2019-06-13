import 'package:flutter/material.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/blocs/MovieBloc.dart';
import 'package:movies_app_bloc/model/MediaFilters.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/util/utils.dart';

class MediaScreen extends StatelessWidget {

  final MediaType mediaType;
  final String category;

  MediaScreen(this.mediaType, this.category);

  @override
  Widget build(BuildContext context) {
    MovieBloc movieBloc = BlocProvider.of<MovieBloc>(context);
    String mediaType = "movie";
    String category = "popular";

    if(this.mediaType.index == 0) {
      mediaType = "movie";
      category = category;
    } else {
      mediaType = "tv";
      category = category;
    }
    return Container(
      height: 150.0,
      width: 150.0,
      // Horizontal list of all movies in the catalog
      // based on the filters
      child: StreamBuilder<List<MediaItem>>(

          stream: movieBloc.outMoviesList,
          builder: (BuildContext context,
              AsyncSnapshot<List<MediaItem>> snapshot) {
            int page = 1;
            if(snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount:
              (snapshot.data == null ? 0 : snapshot.data.length),
              itemBuilder: (BuildContext context, int index) {

                print("PopularScreen MediaListItem snapshot.data.length " + snapshot.data.length.toString() );
                print("PopularScreen build..................... " + index.toString());
                for(int i = 0; i < snapshot.data.length; i++ ) {
                  print("PopularScreen MediaListItem " + snapshot.data[i].toJson().toString());
                }
                if ( index > (snapshot.data.length * 0.7)) {
                  print("PopularScreen build........ssss............. page" + page.toString());
                  print("PopularScreenbuild........ssss............. " + index.toString());
                  page += 1;
                  MediaFilters data = MediaFilters(page, mediaType, category);
                  movieBloc.inFilters.add(data);
                }
                return MediaListItem(snapshot.data[index], index, movieBloc, snapshot.data.length);
              },
            );
          }),
    );
  }

}
class MediaListItem extends StatelessWidget {

  final MediaItem movie;
  final int index;
  final int length;
  MediaListItem(this.movie, this.index, this._movieBloc, this.length);
  final MovieBloc _movieBloc;
  
  Widget _getTitleSection(BuildContext context) {



    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    movie.title,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    getGenreString(movie.genreIds),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.body1,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  Icon(
                    Icons.star,
                    size: 16.0,
                  )
                ],
              ),
              Container(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    movie.getReleaseYear().toString(),
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  Icon(
                    Icons.date_range,
                    size: 16.0,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Card(
      child: InkWell(
//        onTap: () => goToMovieDetails(context, movie),
        child: Column(
          children: <Widget>[
            Hero(
              child: FadeInImage.assetNetwork(
                placeholder: "assets/placeholder.jpg",
                image: movie.getBackDropUrl(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
                fadeInDuration: Duration(milliseconds: 50),
              ),
              tag: "Movie-Tag-${movie.id}",
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}