import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LocalStorageService {
  final Dio _dio = Dio();

  Future<void> saveImage(BuildContext context, String imageUrl, String fileName) async {
    try {
      // Fetch the image data using Dio
      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Get the directory to save the image
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Failed to get the directory');
      }

      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      // Write the image data to the file
      await file.writeAsBytes(response.data as List<int>);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to gallery: $filePath')),
      );
    
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      print('Platform Exception: $e');
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
    }
  }
}
