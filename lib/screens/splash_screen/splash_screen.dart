import 'package:flutter/material.dart';

import '../scan_screen/scan_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((_) {
      if (mounted) {
        // Check if the widget is still mounted
        Navigator.pushReplacementNamed(context, ScannerScreen.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
