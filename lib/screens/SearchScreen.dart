
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/blocs/SearchBloc.dart';
import 'package:movies_app_bloc/model/SearchResult.dart';
import 'package:movies_app_bloc/util/Styles.dart';
import 'package:movies_app_bloc/util/Utils.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> {
  SearchBar searchBar;
  TextEditingController textController = TextEditingController();
  SearchBloc searchBloc;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: searchBar.build(context), body: _buildContentSection());
  }

  Widget _buildContentSection() {

    if( searchBloc != null) {
      return Container(
        child: StreamBuilder<List<SearchResult>>(
            stream: searchBloc.outSearchMediaList,
            builder: (BuildContext context,
                AsyncSnapshot<List<SearchResult>> snapshot) {
              if(snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return (snapshot.data == null || snapshot.data.length == 0)
                  ? Center(
                  child: Text("Unforunately there aren't any matching results!"))
                  : ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      SearchItemCard(snapshot.data[index]));
            }),
      );
    } else {
      return Center(child: Text("Search for movies, shows and actors"));
    }

  }

  _SearchPageState() {

    searchBar = SearchBar(
        inBar: true,
        controller: textController,
        setState: setState,
        buildDefaultAppBar: _buildAppBar,
        onSubmitted: search(),
        );
  }

  void _createBloc(String query) {
    print("SearchScreen.... initState ..... text search _createBloc " + textController.text.toString());
    if(query != null || query != "") {
      searchBloc = SearchBloc(query);
      searchBloc.inSearchMovie.add(query);
    }


  }


  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      _createBloc(textController.text.toString());
    });

  }



  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text('Search Movies'),
        actions: [searchBar.getSearchAction(context)]);
  }

  search() {
    print("SearchScreen...ssss. initState ..... text search " + textController.text.toString());
  }

}


class SearchItemCard extends StatelessWidget {
  final SearchResult item;

  SearchItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
//        onTap: () => _handleTap(context),
        child: Row(
          children: <Widget>[
            FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                width: 100.0,
                height: 150.0,
                placeholder: "assets/placeholder.jpg",
                image: item.imageUrl),
            Container(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(item.mediaType.toUpperCase(),
                          style: TextStyle(color: colorAccent)),
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Text(item.subtitle, style: captionStyle)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//  _handleTap(BuildContext context) {
//    switch (item.mediaType) {
//      case "movie":
//        goToMovieDetails(context, item.asMovie);
//        return;
//      case "tv":
//        goToMovieDetails(context, item.asShow);
//        return;
//      case "person":
//        goToActorDetails(context, item.asActor);
//        return;
//    }
//  }
}
