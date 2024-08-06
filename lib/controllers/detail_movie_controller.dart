import 'package:get/get.dart';
import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';

class DetailMovieController extends GetxController {
  var movie = Rx<Movie>(Movie(
    id: 0,
    title: '',
    posterPath: '',
    overview: '',
    rating: 0.0,
  ));
  var similarMovies = <Movie>[].obs;
  var isLoading = true.obs;

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
