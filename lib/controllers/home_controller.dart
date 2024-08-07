import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:flutter_application_moviedb/services/auth_service.dart';
import 'package:get/get.dart';

/// The `HomeController` manages the state and logic for the home screen.
/// It fetches and maintains the lists of now playing, popular, watchlist, and favorite movies.
/// It also handles adding movies to the watchlist and favorites.
class HomeController extends GetxController {
  /// The API service instance used for making API calls.
  final ApiService apiService = Get.put(ApiService());

  /// The list of movies currently playing in theaters.
  var nowPlayingMovies = <Movie>[].obs;

  /// The list of popular movies.
  var popularMovies = <Movie>[].obs;

  /// The list of movies added to the watchlist.
  var watchlistMovies = <Movie>[].obs;

  /// The list of movies marked as favorites.
  var favoriteMovies = <Movie>[].obs;

  /// Indicates whether data is still being loaded.
  var isLoading = true.obs;

  /// Initializes the controller by fetching movies and setting up the session.
  ///
  /// This method is called when the controller is first initialized. It calls
  /// [initializeSession] to set up the user session and then fetches movies
  /// by calling [fetchNowPlayingMovies], [fetchPopularMovies], [fetchFavoriteMovies],
  /// and [fetchWatchlistMovies].
  @override
  void onInit() {
    super.onInit();
    initializeSession();
    fetchNowPlayingMovies();
    fetchPopularMovies();
    fetchFavoriteMovies();
    fetchWatchlistMovies();
  }

  /// Initializes the user session by retrieving the session ID.
  ///
  /// If the session ID is successfully retrieved, it fetches the watchlist and
  /// favorite movies. If not, it shows an error message.
  void initializeSession() async {
    try {
      final sessionId = await AuthService.getSessionId();
      if (sessionId == null) {
        throw Exception('Session ID is not available.');
      }
      Get.snackbar('Session Initialized', 'Successfully logged in.');

      // Fetch watchlist and favorite movies
      fetchWatchlistMovies();
      fetchFavoriteMovies();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize session: $e');
    }
  }

  /// Adds a movie to the watchlist.
  ///
  /// [movie] is the movie to be added to the watchlist. This method retrieves
  /// the session ID, adds the movie to the watchlist using the API, and updates
  /// the local watchlist. It also shows a snackbar message confirming the addition
  /// or displaying an error if it fails.
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

  /// Adds a movie to the favorites list.
  ///
  /// [movie] is the movie to be added to the favorites. This method retrieves
  /// the session ID, adds the movie to the favorites using the API, and updates
  /// the local favorites list. It also shows a snackbar message confirming the addition
  /// or displaying an error if it fails.
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

  /// Fetches the list of now playing movies from the API.
  ///
  /// This method sets [isLoading] to true before making the API call and sets it
  /// to false after the data has been fetched and assigned to [nowPlayingMovies].
  void fetchNowPlayingMovies() async {
    try {
      isLoading(true);
      final result = await apiService.getNowPlayingMovies();
      nowPlayingMovies.assignAll(result.take(6));
    } finally {
      isLoading(false);
    }
  }

  /// Fetches the list of popular movies from the API.
  ///
  /// This method sets [isLoading] to true before making the API call and sets it
  /// to false after the data has been fetched and assigned to [popularMovies].
  void fetchPopularMovies() async {
    try {
      isLoading(true);
      final result = await apiService.getPopularMovies();
      popularMovies.assignAll(result.take(20));
    } finally {
      isLoading(false);
    }
  }

  /// Fetches the list of watchlist movies from the API.
  ///
  /// This method retrieves the session ID, makes an API call to get the watchlist
  /// movies, and updates [watchlistMovies]. It shows an error message if the session
  /// ID is not available or if the API call fails.
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

  /// Fetches the list of favorite movies from the API.
  ///
  /// This method retrieves the session ID, makes an API call to get the favorite
  /// movies, and updates [favoriteMovies]. It shows an error message if the session
  /// ID is not available or if the API call fails.
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

  /// Checks if a movie is marked as a favorite.
  ///
  /// [movieId] is the ID of the movie to check. Returns true if the movie is in
  /// the list of favorite movies, otherwise returns false.
  bool isMovieFavorite(int movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }

  /// Checks if a movie is in the watchlist.
  ///
  /// [movieId] is the ID of the movie to check. Returns true if the movie is in
  /// the watchlist, otherwise returns false.
  bool isMovieWatchlisted(int movieId) {
    return watchlistMovies.any((movie) => movie.id == movieId);
  }
}
