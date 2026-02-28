import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../data/course_data.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    name: 'John Doe',
    email: 'johndoe@example.com',
    avatar: 'assets/images/John Doe.jpg',
    bio:
        'Passionate learner exploring the world of mobile development and UI/UX design.',
    joinDate: 'Feb 2024',
    coursesCompleted: 12,
    learningHours: 156,
    ongoingCourseIds: {'9', '13', '15'},
    completedCourseIds: {'16'},
    favoriteCourseIds: {'1', '3', '5'}, // Initial dummy favorites
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

  bool isFavorite(String courseId) {
    return _user.favoriteCourseIds.contains(courseId);
  }

  void toggleFavorite(String courseId) {
    final newFavorites = Set<String>.from(_user.favoriteCourseIds);
    if (newFavorites.contains(courseId)) {
      newFavorites.remove(courseId);
    } else {
      newFavorites.add(courseId);
    }
    _user = _user.copyWith(favoriteCourseIds: newFavorites);
    _saveFavoriteCourseIds();
    notifyListeners();
  }

  // Track hours dynamically
  int get totalEstimatedHours {
    double total = 0;
    final allEnrolledIds = {
      ..._user.ongoingCourseIds,
      ..._user.completedCourseIds
    };

    for (var id in allEnrolledIds) {
      final course = courseData.firstWhere((c) => c.id == id,
          orElse: () => courseData[0]); // fallback if not found
      // Parse "3.5 hours" or "2 hours"
      String durationStr = course.duration.split(' ')[0];
      double hours = double.tryParse(durationStr) ?? 0;
      total += hours;
    }
    return total.round();
  }

  int get totalCoursesCount {
    return _user.ongoingCourseIds.length + _user.completedCourseIds.length;
  }

  List<String> get allEnrolledCourseNames {
    final allIds = {..._user.ongoingCourseIds, ..._user.completedCourseIds};
    final names = <String>[];
    for (var id in allIds) {
      final course = courseData.firstWhere((c) => c.id == id,
          orElse: () => courseData[0]);
      names.add(course.title);
    }
    return names;
  }

  void enrollInCourse(String courseId) {
    if (!_user.ongoingCourseIds.contains(courseId) &&
        !_user.completedCourseIds.contains(courseId)) {
      final newOngoing = Set<String>.from(_user.ongoingCourseIds)..add(courseId);
      _user = _user.copyWith(ongoingCourseIds: newOngoing);
      _saveCourseIds();
      notifyListeners();
    }
  }

  Future<void> updateEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    _user = _user.copyWith(email: email);
    notifyListeners();
  }

  void completeCourse(String courseId) {
    if (_user.ongoingCourseIds.contains(courseId)) {
      final newOngoing = Set<String>.from(_user.ongoingCourseIds)
        ..remove(courseId);
      final newCompleted = Set<String>.from(_user.completedCourseIds)
        ..add(courseId);
      _user = _user.copyWith(
        ongoingCourseIds: newOngoing,
        completedCourseIds: newCompleted,
      );
      _saveCourseIds();
      notifyListeners();
    }
  }

  UserProvider() {
    _loadUserFromPrefs();
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'John Doe';
    final email = prefs.getString('user_email') ?? 'johndoe@example.com';
    final avatar =
        prefs.getString('user_avatar') ?? 'assets/images/John Doe.jpg';
    final bio = prefs.getString('user_bio') ?? _user.bio;
    final phoneNumber = prefs.getString('user_phone') ?? _user.phoneNumber;

    final ongoingList = prefs.getStringList('ongoing_course_ids');
    final completedList = prefs.getStringList('completed_course_ids');
    final favoriteList = prefs.getStringList('favorite_course_ids');

    _user = _user.copyWith(
      name: name,
      email: email,
      avatar: avatar,
      bio: bio,
      phoneNumber: phoneNumber,
      ongoingCourseIds: ongoingList?.toSet() ?? _user.ongoingCourseIds,
      completedCourseIds: completedList?.toSet() ?? _user.completedCourseIds,
      favoriteCourseIds: favoriteList?.toSet() ?? _user.favoriteCourseIds,
    );
    notifyListeners();
  }

  Future<void> _saveCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'ongoing_course_ids', _user.ongoingCourseIds.toList());
    await prefs.setStringList(
        'completed_course_ids', _user.completedCourseIds.toList());
  }

  Future<void> _saveFavoriteCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'favorite_course_ids', _user.favoriteCourseIds.toList());
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
