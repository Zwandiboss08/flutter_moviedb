import 'package:flutter/material.dart';
import 'package:flutter_application_moviedb/controllers/detail_movie_controller.dart';
import 'package:flutter_application_moviedb/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailMovieScreen extends StatelessWidget {
  final int movieId;
  final DetailMovieController detailMovieController =
      Get.put(DetailMovieController());

  DetailMovieScreen({required this.movieId, super.key}) {
    detailMovieController.fetchMovieDetails(movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: Obx(() {
        if (detailMovieController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = detailMovieController.movie.value;
        final similarMovies = detailMovieController.similarMovies;

        return ListView(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(movie.overview),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Similar Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: similarMovies.length,
                itemBuilder: (context, index) {
                  final similarMovie = similarMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Get.offAll(HomeScreen());
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Get.to(
                            () => DetailMovieScreen(movieId: similarMovie.id));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${similarMovie.posterPath}',
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          Text(similarMovie.title,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
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
