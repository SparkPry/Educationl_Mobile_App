import 'package:education_app/screens/category_screen.dart';
import 'package:education_app/screens/course_screen.dart';
import 'package:education_app/screens/filter_screen.dart';
import 'package:education_app/screens/forgot_password_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:education_app/screens/new_password_screen.dart';
import 'package:education_app/screens/notification_screen.dart';
import 'package:education_app/screens/onboarding_screen.dart';
import 'package:education_app/screens/search_screen.dart';
import 'package:education_app/screens/splash_screen.dart';
import 'package:education_app/screens/verification_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:education_app/screens/my_courses_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      return const HomeScreen();
    } else {
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
