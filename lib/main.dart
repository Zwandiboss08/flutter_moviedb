import 'package:flutter/material.dart';
import 'package:flutter_application_moviedb/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter_application_moviedb/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX dependency injection
  final authService = AuthService();
  Get.put(AuthService());

  final sessionId = await AuthService.getSessionId();
  if (sessionId == null) {
    // Perform login if no session ID exists
    // Example: use default credentials or prompt user input
    final username = 'zwandiboss';
    final password = 'jaeger08';
    try {
      await authService.login(username, password);
      // Session successfully created or retrieved
      Get.snackbar('Login Successful', 'Session initialized');
    } catch (e, stackTrace) {
      print('ada error $e');
      print('ada error di $stackTrace');
      Get.snackbar('Login Error', 'Failed to login: $e');
    }
  } else {
    // Session exists, proceed as usual
    Get.snackbar('Session Found', 'Session already active');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie DB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
