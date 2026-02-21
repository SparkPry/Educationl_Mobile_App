import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  // If `nextRoute` is provided, the splash will navigate to that route
  // after [duration]. If null, the splash simply displays the logo.
  final String? nextRoute;
  final Duration duration;

  const SplashScreen({super.key, this.nextRoute, this.duration = const Duration(seconds: 3)});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After the splash duration, navigate to the provided route
    // or fall back to the onboarding route.
    Future.delayed(widget.duration, () {
      if (!mounted) return;
      final target = widget.nextRoute ?? '/onboarding';
      Navigator.pushReplacementNamed(context, target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Image.asset(
          'assets/images/AngkorEdu.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
