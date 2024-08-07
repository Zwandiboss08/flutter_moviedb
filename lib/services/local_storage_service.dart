import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/services.dart';

class LocalStorageService {
  final Dio _dio = Dio();

  Future<void> saveImage(BuildContext context, String imageUrl, String fileName) async {
    try {
      // Check and request permissions
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied to save image')),
        );
        return;
      }

      // Fetch the image data using Dio
      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the directory to save the image
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Write the image data to the file
      await file.writeAsBytes(response.data as List<int>);

      // Save the image to the gallery
      final result = await ImageGallerySaver.saveFile(filePath);
      if (result["isSuccess"]) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to gallery: $filePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Failed to save image to gallery')),
        );
      }
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Platform Exception: $e')),
      );
    } catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
