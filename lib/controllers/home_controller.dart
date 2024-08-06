import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:flutter_application_moviedb/services/local_storage_service.dart'; // Import LocalStorageService
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable lists to store Now Playing and Popular movies
  var nowPlayingMovies = <Movie>[].obs;
  var popularMovies = <Movie>[].obs;

  // Observable variable to track loading state
  var isLoading = true.obs;

  final LocalStorageService localStorageService = LocalStorageService(); // Create an instance of LocalStorageService

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

  // Method to add a movie to the watchlist
  void addToWatchlist(Movie movie) {
    // You might want to add logic to save to a database or local storage
    // For now, this is just a placeholder
    print('Added to watchlist: ${movie.title}');
  }

  // Method to add a movie to favorites
  void addToFavorite(Movie movie) {
    // You might want to add logic to save to a database or local storage
    // For now, this is just a placeholder
    print('Added to favorites: ${movie.title}');
  }
}
