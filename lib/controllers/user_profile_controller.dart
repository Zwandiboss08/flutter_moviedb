import 'package:get/get.dart';
import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:flutter_application_moviedb/services/auth_service.dart'; // Import AuthService for sessionId

/// The `UserProfileController` manages the state and logic for the user profile screen.
/// It fetches and maintains user details, including watchlist and favorite movies.
class UserProfileController extends GetxController {
  /// Indicates whether data is still being loaded.
  var isLoading = true.obs;

  /// The user's name.
  var userName = ''.obs;

  /// The user's email address.
  var userEmail = ''.obs;

  /// The path to the user's avatar image.
  var avatarPath = ''.obs;

  /// The list of movies in the user's watchlist.
  var watchlistMovies = <Movie>[].obs;

  /// The list of movies marked as favorites by the user.
  var favoriteMovies = <Movie>[].obs;

  /// The ID of the account for which details are fetched.
  final int accountId;

  /// Creates an instance of `UserProfileController` with the given [accountId].
  UserProfileController(this.accountId);

  /// Initializes the controller by fetching user details.
  ///
  /// This method is called when the controller is first initialized. It calls
  /// [fetchUserDetails] to fetch the user's details, watchlist, and favorite movies.
  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

  /// Fetches the user's details, watchlist, and favorite movies.
  ///
  /// This method retrieves the session ID from [AuthService], and then uses it to fetch
  /// user details and movies from [ApiService]. It updates the `userName`, `userEmail`,
  /// `avatarPath`, `watchlistMovies`, and `favoriteMovies` properties with the fetched data.
  /// If any errors occur during fetching, they are printed to the console.
  Future<void> fetchUserDetails() async {
    try {
      isLoading.value = true;
      final sessionId = await AuthService.getSessionId(); // Ensure AuthService.getSessionId() returns the session ID

      if (sessionId == null) {
        throw Exception('Session ID is not available.');
      }

      // Fetch user details
      final userDetails = await ApiService().getUserDetails(accountId, sessionId);
      userName.value = userDetails['username'] ?? 'N/A';
      userEmail.value = userDetails['email'] ?? 'N/A'; // Adjust as needed
      avatarPath.value = userDetails['avatar']['gravatar']['hash'] ?? '';

      // Fetch watchlist and favorite movies
      watchlistMovies.value = await ApiService().getWatchlistMovies(sessionId);
      favoriteMovies.value = await ApiService().getFavoriteMovies(sessionId);
    } catch (e) {
      print('Error fetching user details: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
