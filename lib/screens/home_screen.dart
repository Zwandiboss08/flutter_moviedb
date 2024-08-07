import 'package:flutter/material.dart';
import 'package:flutter_application_moviedb/controllers/home_controller.dart';
import 'package:flutter_application_moviedb/screens/detail_movie_screen.dart';
import 'package:flutter_application_moviedb/screens/user_profile_screen.dart';
import 'package:flutter_application_moviedb/services/local_storage_service.dart';
import 'package:flutter_application_moviedb/widgets/skeleton_loaders.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// HomeScreen displays the main interface for the app.
/// It includes sections for "Now Playing" and "Popular" movies.
/// Each section allows users to interact with the movie items, including
/// viewing details, adding to watchlist or favorites, and saving images.
class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final LocalStorageService localStorageService =
      LocalStorageService(); // Create an instance of the service

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Get.to(() => UserProfileScreen());
            },
          ),
        ],
      ),
      body: Obx(() {
        // Check if the data is still loading
        if (homeController.isLoading.value) {
          return ListView(
            children: [
              // Display 'Now Playing' section with skeleton loaders
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Now Playing',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 200, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6, // Number of skeleton loaders to display
                  itemBuilder: (context, index) {
                    return const SkeletonLoader();
                  },
                ),
              ),
              // Display 'Popular' section with skeleton loaders
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Popular',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 20, // Number of skeleton loaders to display
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const SkeletonLoader(),
                      title: Container(
                        height: 20,
                        color: Colors.grey[300],
                      ),
                      subtitle: Container(
                        height: 14,
                        color: Colors.grey[300],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        // Display the actual data
        return ListView(
          children: [
            // Display 'Now Playing' section with movies
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Now Playing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 270, // Adjust height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.nowPlayingMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.nowPlayingMovies[index];

                  bool isFavorite = homeController.isMovieFavorite(movie.id);
                  bool isWatchlisted =
                      homeController.isMovieWatchlisted(movie.id);
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the DetailMovieScreen when a movie is tapped
                      Get.to(() => DetailMovieScreen(movieId: movie.id));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          Text(movie.title,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isWatchlisted
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color:
                                      isWatchlisted ? Colors.blue : Colors.grey,
                                ),
                                onPressed: () {
                                  homeController.addToWatchlist(movie);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  homeController.addToFavorite(movie);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  localStorageService.saveImage(
                                    context, 
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    '${movie.id}_poster.jpg',
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Display 'Popular' section with movies
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Popular',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: homeController.popularMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.popularMovies[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the DetailMovieScreen when a movie is tapped
                      Get.to(() => DetailMovieScreen(movieId: movie.id));
                    },
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(movie.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.overview,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
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
