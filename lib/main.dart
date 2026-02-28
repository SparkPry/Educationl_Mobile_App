import 'package:education_app/screens/nickname_screen.dart';
import 'package:education_app/screens/category_screen.dart';
import 'package:education_app/screens/course_screen.dart';
import 'package:education_app/screens/filter_screen.dart';
import 'package:education_app/screens/forgot_password_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_app/services/api_service.dart';

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
import 'package:education_app/screens/my_favorite_screen.dart';

import 'package:education_app/providers/payment_provider.dart';
import 'package:education_app/screens/aba_qr_payment_screen.dart';
import 'package:education_app/screens/add_payment_screen.dart';
import 'package:education_app/screens/change_password_screen.dart';
import 'package:education_app/screens/e_receipt_screen.dart';
import 'package:education_app/screens/edit_profile_screen.dart';
import 'package:education_app/screens/find_friends_screen.dart';
import 'package:education_app/screens/help_center_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/invite_friends_screen.dart';
import 'package:education_app/screens/learning_screen.dart';
import 'package:education_app/screens/lesson_list_screen.dart';
import 'package:education_app/screens/mentor_profile_screen.dart';
import 'package:education_app/screens/message_conversation_screen.dart';
import 'package:education_app/screens/payment_method_screen.dart';
import 'package:education_app/screens/payment_screen.dart';
import 'package:education_app/screens/privacy_policy_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/quiz_screen.dart';
import 'package:education_app/screens/security_screen.dart';
import 'package:education_app/screens/student_courses_list_screen.dart';
import 'package:education_app/screens/student_profile_screen.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/models/mentor_model.dart';
import 'package:education_app/models/user_model.dart';
import 'package:education_app/models/payment_method.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();

    // Add a minimum splash duration of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if onboarding was already seen
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      // First time opening the app: return onboarding screen
      return const OnboardingScreen();
    }

    // Check login token
    final token = prefs.getString('token');

    if (token != null) {
      // Token exists, validate it with API
      try {
        final apiService = ApiService();
        await apiService.getProfile(token).timeout(const Duration(seconds: 5));
        // Token is valid
        return const HomeScreen();
      } catch (e) {
        // Token is invalid, expired or connection timed out
        debugPrint('Token validation failed or timed out: $e');
        // Clear invalid token
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
        '/nickname': (context) => const NicknameScreen(),
        '/favorites': (context) => const MyFavoriteScreen(),





















      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/aba_qr_payment':
            final course = settings.arguments as Course;
            return MaterialPageRoute(builder: (_) => AbaQrPaymentScreen(course: course));
          case '/add_payment':
            final args = settings.arguments as Map<String, dynamic>;
            final course = args['course'] as Course?;
            final paymentType = args['paymentType'] as PaymentType;
            return MaterialPageRoute(
              builder: (_) => AddPaymentScreen(course: course, paymentType: paymentType),
            );
          case '/change_password':
            return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
          case '/e_receipt':
            final args = settings.arguments as Map<String, dynamic>;
            final course = args['course'] as Course;
            final paymentMethodDetail = args['paymentMethodDetail'] as String;
            final paymentMethod = args['paymentMethod'] as PaymentMethod?;
            return MaterialPageRoute(
              builder: (_) => EReceiptScreen(
                course: course,
                paymentMethodDetail: paymentMethodDetail,
                paymentMethod: paymentMethod,
              ),
            );
          case '/edit_profile':
            return MaterialPageRoute(builder: (_) => const EditProfileScreen());
          case '/find_friends':
            return MaterialPageRoute(builder: (_) => const FindFriendsScreen());
          case '/help_center':
            return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
          case '/inbox':
            return MaterialPageRoute(builder: (_) => const InboxScreen());
          case '/invite_friends':
            return MaterialPageRoute(builder: (_) => const InviteFriendsScreen());
          case '/learning':
            final course = settings.arguments as Course;
            return MaterialPageRoute(builder: (_) => LearningScreen(course: course));
          case '/lesson_list':
            return MaterialPageRoute(builder: (_) => const LessonListScreen());
          case '/mentor_profile':
            final mentor = settings.arguments as Mentor;
            return MaterialPageRoute(builder: (_) => MentorProfileScreen(mentor: mentor));
          case '/message_conversation':
            final args = settings.arguments as Map<String, dynamic>;
            final chatUser = args['chatUser'] as UserModel;
            final isMentor = args['isMentor'] as bool? ?? false;
            return MaterialPageRoute(
              builder: (_) => MessageConversationScreen(
                chatUser: chatUser,
                isMentor: isMentor,
              ),
            );
          case '/payment_method':
            return MaterialPageRoute(builder: (_) => const PaymentMethodScreen());
          case '/payment':
            final course = settings.arguments as Course;
            return MaterialPageRoute(builder: (_) => PaymentScreen(course: course));
          case '/privacy_policy':
            return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/quiz':
            return MaterialPageRoute(builder: (_) => const QuizScreen());
          case '/security':
            return MaterialPageRoute(builder: (_) => const SecurityScreen());
          case '/student_courses_list':
            final args = settings.arguments as Map<String, dynamic>;
            final studentName = args['studentName'] as String;
            final courses = args['courses'] as List<String>;
            return MaterialPageRoute(
              builder: (_) => StudentCoursesListScreen(
                studentName: studentName,
                courses: courses,
              ),
            );
          case '/student_profile':
            final student = settings.arguments as UserModel;
            return MaterialPageRoute(builder: (_) => StudentProfileScreen(student: student));
          case '/course':
            return MaterialPageRoute(builder: (_) => const CourseScreen());
          default:
            return null; // Let onUnknownRoute handle it or show an error
        }
      },
    );
  }
}


