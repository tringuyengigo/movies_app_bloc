import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app_bloc/blocs/BlocProvider.dart';
import 'package:movies_app_bloc/blocs/MovieBloc.dart';
import 'package:movies_app_bloc/model/MediaItem.dart';
import 'package:movies_app_bloc/screens/MediaScreen.dart';
import 'package:movies_app_bloc/util/Navigator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  MediaType mediaType = MediaType.movie;
  String category = "popular";
  String typeMedia = "Movies";
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    if(mediaType.index == 0) {
      typeMedia = "Movies";
    } else {
      typeMedia = "TV Shows";
    }
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () => goToSearch(context),
            )
          ],

          title: Text(typeMedia),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff2b5876),
                          const Color(0xff4e4376),
                        ])),
                  )),
              ListTile(
                title: Text("Search"),
                trailing: Icon(Icons.search),
                onTap: () => goToSearch(context),
              ),
              ListTile(
                title: Text("Favorites"),
                trailing: Icon(Icons.favorite),
//                onTap: () => goToFavorites(context),
              ),
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text("Movies"),
                selected: mediaType == MediaType.movie,
                trailing: Icon(Icons.local_movies),
                onTap: () {
                  _changeMediaType(MediaType.movie);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("TV Shows"),
                selected: mediaType == MediaType.show,
                trailing: Icon(Icons.live_tv),
                onTap: () {
                  _changeMediaType(MediaType.show);
                  Navigator.of(context).pop();
                },
              ),
              Divider(
                height: 5.0,
              ),
              ListTile(
                title: Text("Close"),
                trailing: Icon(Icons.close),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ),
        body: PageView(
          children: _getMediaList(mediaType, category),
          pageSnapping: true,
          controller: _pageController,
          onPageChanged: (int index) {
            setState(() {
              _page = index;
              print("HomeScreen current _page = " + _page.toString());
              if(_page == 0) {
                category = "popular";
              } else if(_page == 1) {
                if(this.mediaType.index == 0) {
                  category = "upcoming";
                } else {
                  category = "on_the_air";
                }
              } else if(_page == 2) {
                category = "top_rated";
              } else {
                category = "popular";
              }
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _getNavBarItems(),
          onTap: _navigationTapped,
          currentIndex: _page,
        ),
    );
  }

  List<Widget> _getMediaList(MediaType mediaType, String category) {
    return <Widget>[
      listPopularMediaWidget(mediaType, category),
      listTopRateMediaWidget(mediaType, category),
      listUpComingMediaWidget(mediaType, category),
    ];
  }
  
  Widget listPopularMediaWidget(MediaType mediaType, String category) => BlocProvider<MovieBloc>(
    bloc: MovieBloc(mediaType, category),
    child: MediaScreen(mediaType, category),
  );

  Widget listTopRateMediaWidget(MediaType mediaType, String category) => BlocProvider<MovieBloc>(
    bloc: MovieBloc(mediaType, category),
    child: MediaScreen(mediaType, category),
  );

  Widget listUpComingMediaWidget(MediaType mediaType, String category) => BlocProvider<MovieBloc>(
    bloc: MovieBloc(mediaType, category),
    child: MediaScreen(mediaType, category),
  );




  List<BottomNavigationBarItem> _getNavBarItems() {
    if (mediaType == MediaType.movie) {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), title: Text('Popular')),
        BottomNavigationBarItem(
            icon: Icon(Icons.update), title: Text('Upcoming')),
        BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Top Rated')),
      ];
    } else {
      return [
        BottomNavigationBarItem(
            icon: Icon(Icons.thumb_up), title: Text('Popular')),
        BottomNavigationBarItem(
            icon: Icon(Icons.live_tv), title: Text('On The Air')),
        BottomNavigationBarItem(
            icon: Icon(Icons.star), title: Text('Top Rated')),
      ];
    }
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  void _navigationTapped(int page) {
    print("HomeScreenViewModel -> updateMedia() page " + page.toString());

    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  
  
}



