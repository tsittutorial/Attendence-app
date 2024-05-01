// ignore: file_names
// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'selection_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // Wait for a few seconds and then navigate to the selection page
    Timer(const Duration(seconds: 5), () {

    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectionPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
