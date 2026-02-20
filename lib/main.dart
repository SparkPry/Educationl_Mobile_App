import 'package:education_app/screens/category_screen.dart';
import 'package:education_app/screens/course_screen.dart';
import 'package:education_app/screens/filter_screen.dart';
import 'package:education_app/screens/forgot_password_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'package:education_app/screens/new_password_screen.dart';
import 'package:education_app/screens/notification_screen.dart';
import 'package:education_app/screens/onboarding_screen.dart';
import 'package:education_app/screens/search_screen.dart';
import 'package:education_app/screens/splash_screen.dart';
import 'package:education_app/screens/verification_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:education_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:education_app/screens/my_courses_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if onboarding was already seen
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    // Check login token
    final token = prefs.getString('token');

    if (!seenOnboarding) {
      // First time opening the app
      return const OnboardingScreen();
    } else if (token != null) {
      // Token exists, validate it with API
      try {
        final apiService = ApiService();
        await apiService.getProfile(token);
        // Token is valid
        return const HomeScreen();
      } on DioException catch (e) {
        // Token is invalid or expired
        debugPrint('Token validation failed: ${e.message}');
        // Clear invalid token
        await prefs.remove('token');
        await prefs.remove('role');
        return const LoginScreen();
      } catch (e) {
        // Error validating token
        debugPrint('Error validating token: $e');
        // Clear potentially invalid token
        await prefs.remove('token');
        await prefs.remove('role');
        return const LoginScreen();
      }
    } else {
      // Not logged in yet
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: FutureBuilder<Widget>(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // show splash while checking
          }

          if (snapshot.hasData) {
            return snapshot.data!;
          }

          return const LoginScreen();
        },
      ),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/new_password': (context) => const NewPasswordScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/search': (context) => const SearchScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/myCourses': (context) => const MyCoursesScreen(),
        '/category': (context) => const CategoryScreen(),
        '/course': (context) => const CourseScreen(),
        '/filter': (context) => const FilterScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}
