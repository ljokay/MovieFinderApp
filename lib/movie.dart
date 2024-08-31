class Movie {
  int? id;
  String title = "Placeholder";
  double? voteAverage;
  String? releaseDate;
  String overview = "Placeholder";
  String posterPath = "Placeholder";

  Movie(this.id, this.title, this.voteAverage,
   this.overview, this.posterPath);

  //Formates data in JSON format.
  Movie.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    title = parsedJson['title'];
    voteAverage = parsedJson['vote_average'] * 1.0;
    releaseDate = parsedJson['release_date'];
    overview = parsedJson['overview'];
    posterPath = parsedJson['poster_path'];
  }
}