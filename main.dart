import 'package:flutter/material.dart';
import 'splashscreenpage.dart'; // Import the SplashScreenPage widget

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: NewWidget(), // Use SplashScreenPage as the home widget initially
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SplashScreenPage();
  }
}

