//create model for Movie object
class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double rating;

  Movie({required this.id, required this.title, required this.posterPath, required this.overview, required this.rating});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      rating: json['vote_average'].toDouble() ?? 0.0,
    );
  }
}
