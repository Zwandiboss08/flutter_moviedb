import 'package:flutter/material.dart';
import 'package:flutter_application_moviedb/controllers/home_controller.dart';
import 'package:flutter_application_moviedb/controllers/user_profile_controller.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileScreen extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
final UserProfileController userProfileController = Get.put(UserProfileController(21426008)); // Replace with actual accountId

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            // User Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage:  NetworkImage('https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo.png'), // Example URL
                  ),
                  const SizedBox(height: 16),
                  Text(userProfileController.userName.value, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            // Watchlist Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.watchlistMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.watchlistMovies[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: 150,
                        ),
                        const SizedBox(height: 8),
                        Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Favorite Movies Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Favorites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.favoriteMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.favoriteMovies[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                          placeholder: (context, url) => const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          height: 150,
                        ),
                        const SizedBox(height: 8),
                        Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
