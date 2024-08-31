import 'dart:io';
import 'dart:convert';

import 'movie.dart';
import 'package:http/http.dart' as http;


class HttpHelper {
  final String urlKey = 'api_key=9a24ade377dba4dda1cda9abab88da97';
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = "/upcoming?";
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase = 
  'https://api.themoviedb.org/3/search/movie?api_key=9a24ade377dba4dda1cda9abab88da97&query=';
  
  
  Future<List?> getUpcoming () async {
    //Constructs a URL for fetching upcoming movies.
    final String upcoming = urlBase + urlUpcoming + urlKey + urlLanguage;
    
    //HTTP GET request
    final Uri upcomingUri = Uri.parse(upcoming);
    http.Response result = await http.get(upcomingUri);
    //Parses Json Content
    if (result.statusCode == HttpStatus.ok) {
      //Transforms the body of the result from a String into an object.
      final jsonResponse = json.decode(result.body);
      //Parses only the results array
      final moviesMap = jsonResponse['results'];
      //Converts each map in results array into Movie object and collects them into a list.
      List movies = moviesMap.map((i) =>
        Movie.fromJson(i)).toList();
      //Returns the list of Movies
      return movies;
    }
    else {
      //Returns null if HTTP request fails.
      return null;
    }
  }

  Future<List?> getPopular () async {
    final String popular = urlBase + "/popular?" + urlKey + urlLanguage;
    final Uri popularUri = Uri.parse(popular);
    http.Response result = await http.get(popularUri);
    
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);

      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => 
        Movie.fromJson(i)).toList();

      return movies;
    }
    else {
      return null;
    }
  }

  Future<List?> getTop () async {
    final String topRated = urlBase + "/top_rated?" + urlKey + urlLanguage;
    final Uri topRatedUri = Uri.parse(topRated);
    http.Response result = await http.get(topRatedUri);
    
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);

      final moviesMap = jsonResponse['results'];
      List movies = moviesMap.map((i) => 
        Movie.fromJson(i)).toList();
      return movies;
    }
    else {
      return null;
    }
  }

  Future<List?> findMovies(String title) async {
    //Constructs a URL for fetching searched movies.
    final String query = urlSearchBase + Uri.encodeFull(title);
    //HTTP GET request
    final Uri queryUri = Uri.parse(query);
    http.Response result = await http.get (queryUri);
    //Parses Json Content
    if (result.statusCode == HttpStatus.ok) {
      //Transforms body of result from a String into an object.
      final jsonResponse = json.decode(result.body);
      //Parses results array
      final moviesMap = jsonResponse['results'];
      //Converts each map in results array into Movie object and collects them into a list.
      List movies = moviesMap.map((i) =>
      Movie.fromJson(i)).toList();
      return movies;
    }
    else {
       print('HTTP error ${result.statusCode}: ${result.reasonPhrase}');
      return [];
    }
  }
}