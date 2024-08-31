import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie_detail.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  _MovieListState createState() => _MovieListState();
  
}

class _MovieListState extends State<MovieList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Search for Movies....');
  int? moviesCount;
  List movies = [];
  String? result;
  HttpHelper? helper;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 
  'https://images.freeImages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    helper = HttpHelper();
    initializeUp();
    
  }

  void _handleTabSelection() {
    // Handle tab selection here
    print('Selected tab index: ${_tabController.index}');
    // Example: You can perform different actions or update state based on tab index
    switch (_tabController.index) {
      case 0:
        // Initialize method for 'Popular' tab
        initializePopular();
        break;
      case 1:
        // Initialize method for 'Upcoming' tab
        initializeUp();
        break;
      case 2:
        // Initialize method for 'Top Rated' tab
        initializeTop();
        break;
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return DefaultTabController(
        length: 3,
       child: Scaffold(
        appBar: AppBar(title: searchBar,
      actions: <Widget> [
        
        IconButton(
          icon: visibleIcon,
          onPressed: () {
            setState(() {
              if (this.visibleIcon.icon == Icons.search) {  
                this.visibleIcon = Icon(Icons.cancel);
                //Updates searchBar to a TextField for searching
                this.searchBar = TextField(
                  textInputAction: TextInputAction.search,
                  style: TextStyle (
                    color: Colors.black,
                    fontSize: 20.0, ),
                    onSubmitted:(String text) {
                      search(text);
                    }
                  );
              }
              else {
                setState(() {
                  this.visibleIcon = Icon(Icons.search);
                  this.searchBar= Text('Movies');
                });
              }
            });
          }),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: _logout)
      ],
      bottom: TabBar(
        controller: _tabController,
        onTap: (index) {
          _handleTabSelection();
        },
        tabs:[
          Tab(text: 'Popular'),
          Tab(text: 'Upcoming'),
          Tab(text: 'Top Rated')
        ]),),
    
      body: ListView.builder(
        //Sets itemCount to 0 if moviesCount is null. Otherwise sets the itemCount to the moviesCount
        itemCount: (moviesCount==null) ? 0 : moviesCount,
        //Occurs for each item in the ListView
        itemBuilder: (BuildContext context, int position){
          //Checks for image.
          if (movies[position].posterPath != null) {
            image = NetworkImage(
              iconBase + movies[position].posterPath
            );
          }
          //Uses default image if there is no image
          else {
            image = NetworkImage(defaultImage);
          }
          
          return Card(
            color:Colors.white,
            elevation: 2.0,
            child: ListTile(
              //Opens up new page with movie image and overview. 
              //Info is from the movie_detail class
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (_) => MovieDetail(movies[position])
                );
                Navigator.push(context, route);
              },
              title: Text(movies[position].title),
              subtitle: Text('Released: '
              + movies[position].releaseDate + ' - Vote: ' + 
              movies[position].voteAverage.toString()),
              //Displays a Cicle with the image inside.
              leading: CircleAvatar(
              backgroundImage: image,),
            ));
        }
      )));
  }
  
  //Intializes Upcoming Movies.
  Future initializeUp() async {
    movies = (await helper!.getUpcoming())!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  //Intializes Popular Movies.
  Future initializePopular() async {
    movies = (await helper!.getPopular())!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  //Intializes Popular Movies.
  Future initializeTop() async {
    movies = (await helper!.getTop())!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  //Calls findMovies to serach for movie and updates the state to the movies that were found.
  Future search(text) async {
    movies = (await helper!.findMovies(text))!;
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

}