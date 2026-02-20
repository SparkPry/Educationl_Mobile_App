import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    name: 'John Doe',
    email: 'johndoe@example.com',
    avatar: 'assets/images/John Doe.jpg',
    bio: 'Passionate learner exploring the world of mobile development and UI/UX design.',
    joinDate: 'Feb 2024',
    coursesCompleted: 12,
    learningHours: 156,
    enrolledCourseNames: [
      'Advanced Flutter Development',
      'UI/UX Design Fundamentals',
      'Python for Data Science',
      'Digital Marketing Essentials',
      'Web Development with React',
      'Introduction to Machine Learning',
    ],
    certificates: [
      Certificate(
        title: 'Flutter Advanced Development',
        organization: 'AngkorEdu',
        date: 'Jan 2024',
        imageUrl: '',
      ),
      Certificate(
        title: 'UI/UX Mastery',
        organization: 'Design Academy',
        date: 'Dec 2023',
        imageUrl: '',
      ),
    ],
  );

  UserModel get user => _user;

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'John Doe';
    final email = prefs.getString('user_email') ?? 'johndoe@example.com';
    final avatar = prefs.getString('user_avatar') ?? 'assets/images/John Doe.jpg';
    final bio = prefs.getString('user_bio');
    final phoneNumber = prefs.getString('user_phone');

    _user = UserModel(
      name: name,
      email: email,
      avatar: avatar,
      bio: bio,
      phoneNumber: phoneNumber,
    );
    notifyListeners();
  }

  Future<void> updateUser({
    required String name,
    required String email,
    String? bio,
    String? phoneNumber,
    String? avatar,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    if (bio != null) await prefs.setString('user_bio', bio);
    if (phoneNumber != null) await prefs.setString('user_phone', phoneNumber);
    if (avatar != null) await prefs.setString('user_avatar', avatar);

    _user = _user.copyWith(
      name: name,
      email: email,
      bio: bio,
      phoneNumber: phoneNumber,
      avatar: avatar,
    );
    notifyListeners();
  }
}
