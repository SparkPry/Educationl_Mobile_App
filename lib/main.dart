import 'package:education_app/screens/category_screen.dart';
import 'package:education_app/screens/course_screen.dart';
import 'package:education_app/screens/filter_screen.dart';
import 'package:education_app/screens/forgot_password_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/login_screen.dart';
import 'package:education_app/screens/new_password_screen.dart';
import 'package:education_app/screens/notification_screen.dart';
import 'package:education_app/screens/onboarding_screen.dart';
import 'package:education_app/screens/search_screen.dart';
import 'package:education_app/screens/splash_screen.dart';
import 'package:education_app/screens/verification_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/new_password': (context) => const NewPasswordScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/search': (context) => const SearchScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/category': (context) => const CategoryScreen(),
        '/course': (context) => const CourseScreen(),
        '/filter': (context) => const FilterScreen(),
      },
    );
  }
}
