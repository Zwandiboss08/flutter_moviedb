// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_moviedb/controllers/home_controller.dart';
import 'package:flutter_application_moviedb/widgets/skeleton_loaders.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());

   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Home'),
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return ListView(
            children: [
              const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text('Now Playing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6, // Number of skeleton loaders to display
                  itemBuilder: (context, index) {
                    return const SkeletonLoader();
                  },
                ),
              ),
              const Padding(
                padding:  EdgeInsets.all(8.0),
                child: Text('Popular', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

        return ListView(
          children: [
            const Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text('Now Playing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.nowPlayingMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.nowPlayingMovies[index];
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
           const  Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text('Popular', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: homeController.popularMovies.length,
                itemBuilder: (context, index) {
                  var movie = homeController.popularMovies[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    title: Text(movie.title),
                    subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
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
