import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:flutter_application_moviedb/services/auth_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.put(ApiService());
  var nowPlayingMovies = <Movie>[].obs;
  var popularMovies = <Movie>[].obs;
  var watchlistMovies = <Movie>[].obs;
  var favoriteMovies = <Movie>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initializeSession();
    fetchNowPlayingMovies();
    fetchPopularMovies();
    fetchFavoriteMovies();
    fetchWatchlistMovies();
  }
  void initializeSession() async {
    try {
      final sessionId = await AuthService.getSessionId();
      if (sessionId == null) {
        // Handle case where session ID is not available
        throw Exception('Session ID is not available.');
      }
      // Successfully initialized session
      Get.snackbar('Session Initialized', 'Successfully logged in.');

      // Fetch watchlist and favorite movies
      fetchWatchlistMovies();
      fetchFavoriteMovies();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize session: $e');
    }
  }

  Future<void> addToWatchlist(Movie movie) async {
    final sessionId = await AuthService.getSessionId();
    if (sessionId == null) {
      Get.snackbar('Error', 'No active session found.');
      return;
    }

    try {
      await apiService.addToWatchlist(sessionId, movie.id);
      fetchWatchlistMovies();
      watchlistMovies.add(movie);
      Get.snackbar('Added to Watchlist', '${movie.title} has been added to your watchlist.');
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding ${movie.title} to your watchlist.');
    }
  }

  Future<void> addToFavorite(Movie movie) async {
    final sessionId = await AuthService.getSessionId();
    if (sessionId == null) {
      Get.snackbar('Error', 'No active session found.');
      return;
    }

    try {
      await apiService.addToFavorite(sessionId, movie.id);
      fetchFavoriteMovies();
      favoriteMovies.add(movie);

      Get.snackbar('Added to Favorites', '${movie.title} has been added to your favorites.');
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while adding ${movie.title} to your favorites.');
    }
  }

  // Fetch now playing movies
  void fetchNowPlayingMovies() async {
    try {
      isLoading(true);
      final result = await apiService.getNowPlayingMovies();
      nowPlayingMovies.assignAll(result.take(6));
    } finally {
      isLoading(false);
    }
  }

  // Fetch popular movies
  void fetchPopularMovies() async {
    try {
      isLoading(true);
      final result = await apiService.getPopularMovies();
      popularMovies.assignAll(result.take(20));
    } finally {
      isLoading(false);
    }
  }

  // Fetch watchlist movies
  void fetchWatchlistMovies() async {
    final sessionId = await AuthService.getSessionId();
    if (sessionId == null) {
      Get.snackbar('Error', 'No active session found.');
      return;
    }

    try {
      final result = await apiService.getWatchlistMovies(sessionId);
      watchlistMovies.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch watchlist movies: $e');
    }
  }

  // Fetch favorite movies
  void fetchFavoriteMovies() async {
    final sessionId = await AuthService.getSessionId();
    if (sessionId == null) {
      Get.snackbar('Error', 'No active session found.');
      return;
    }

    try {
      final result = await apiService.getFavoriteMovies(sessionId);
      favoriteMovies.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch favorite movies: $e');
    }
  }


  bool isMovieFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  bool isMovieWatchlisted(int movieId) {
    return watchlistMovies.any((movie) => movie.id == movieId);
  }
}
