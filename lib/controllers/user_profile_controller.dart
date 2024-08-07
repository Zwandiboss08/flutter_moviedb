import 'package:get/get.dart';
import 'package:flutter_application_moviedb/models/movie.dart';
import 'package:flutter_application_moviedb/services/api_service.dart';
import 'package:flutter_application_moviedb/services/auth_service.dart'; // Import AuthService for sessionId

class UserProfileController extends GetxController {
  var isLoading = true.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;
  var avatarPath = ''.obs;
  var watchlistMovies = <Movie>[].obs;
  var favoriteMovies = <Movie>[].obs;

  final int accountId;

  UserProfileController(this.accountId);

  @override
  void onInit() {
    super.onInit();
    fetchUserDetails();
  }

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
