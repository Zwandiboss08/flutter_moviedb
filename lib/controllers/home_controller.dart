import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable lists to store Now Playing and Popular movies
  var nowPlayingMovies = <Movie>[].obs;
  var popularMovies = <Movie>[].obs;
  // Observable variable to track loading state
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch movies when the controller is initialized
    fetchMovies();
  }

  // Method to fetch movies from the API
  void fetchMovies() async {
    try {
      isLoading(true);
      var nowPlayingResult = await ApiService().getNowPlayingMovies();
      var popularResult = await ApiService().getPopularMovies();
      // Update the observable lists with the fetched data
      nowPlayingMovies.assignAll(nowPlayingResult);
      popularMovies.assignAll(popularResult);
    } finally {
      // Set loading to false after data is fetched
      isLoading(false);
    }
  }
}
