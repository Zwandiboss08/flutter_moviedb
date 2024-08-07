import 'package:get/get.dart';
import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';

/// The `DetailMovieController` manages the state and logic for the detail movie screen.
/// It fetches the movie details and similar movies from the API.
class DetailMovieController extends GetxController {
  /// Holds the details of the currently viewed movie.
  var movie = Rx<Movie>(const Movie(
    id: 0,
    title: '',
    posterPath: '',
    overview: '',
  ));

  /// Holds a list of movies that are similar to the currently viewed movie.
  var similarMovies = <Movie>[].obs;

  /// Indicates whether the data is still being loaded.
  var isLoading = true.obs;

  /// Fetches the details of a movie and its similar movies from the API.
  ///
  /// This method sets [isLoading] to true before making the API calls, and sets it
  /// to false after the data has been successfully fetched and assigned to [movie]
  /// and [similarMovies].
  ///
  /// [movieId] is the ID of the movie whose details are to be fetched.
  void fetchMovieDetails(int movieId) async {
    try {
      isLoading(true);
      final result = await ApiService().getMovieDetails(movieId);
      movie.value = result;
      final similarMoviesResult = await ApiService().getSimilarMovies(movieId);
      similarMovies.assignAll(similarMoviesResult);
    } finally {
      isLoading(false);
    }
  }
}

