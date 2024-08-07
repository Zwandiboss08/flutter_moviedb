import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:http/http.dart' as http;

/// A class to handle API requests to The Movie Database (TMDb).
class ApiService {
  // API key from themoviedb
  final Dio _dio = Dio();
  static const String apiKey = 'cb6a70b74d1afd03cf90ba15bac01065';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String accountId = '21426008';

  Future<Map<String, dynamic>> getUserDetails(
      int accountId, String sessionId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/account/$accountId?api_key=$apiKey&session_id=$sessionId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user details');
    }
  }

  /// Fetches a list of now playing movies from TMDb.
  Future<List<Movie>> getNowPlayingMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  /// Fetches a list of popular movies from TMDb.
  Future<List<Movie>> getPopularMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));
    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  /// Fetches detailed information about a specific movie by its ID.
  Future<Movie> getMovieDetails(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$id?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  /// Fetches a list of similar movies by using movie ID
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response =
        await _dio.get('$baseUrl/movie/$movieId/similar', queryParameters: {
      'api_key': apiKey,
    });
    final results = response.data['results'] as List;
    return results.map((json) => Movie.fromJson(json)).toList();
  }

  // Fetch watchlist movies
  Future<List<Movie>> getWatchlistMovies(String sessionId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load watchlist movies');
    }
  }

  // Fetch favorite movies
  Future<List<Movie>> getFavoriteMovies(String sessionId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final movies = (data['results'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to load favorite movies');
    }
  }

  /// Function to add to favorite
  Future<void> addToFavorite(String sessionId, int movieId) async {
    final url =
        '$baseUrl/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to favorite');
    }
  }

  /// Function to add to watchlist
  Future<void> addToWatchlist(String sessionId, int movieId) async {
    final url =
        '$baseUrl/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': true,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add to watchlist');
    }
  }
}
