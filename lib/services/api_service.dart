import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL without trailing slash to prevent construction errors
  final String _baseUrl = "https://e-learning-api-production-a6d4.up.railway.app/api";

  Future<Map<String, String>> _getHeaders([String? token]) async {
    final prefs = await SharedPreferences.getInstance();
    final effectiveToken = token ?? prefs.getString('token');
    
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (effectiveToken != null) "Authorization": "Bearer $effectiveToken",
    };
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/auth/login");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
  }

  Future<http.Response> register(String name, String email, String password) async {
    final url = Uri.parse("$_baseUrl/auth/register");
    return await http.post(
      url,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
  }

  Future<http.Response> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? phoneNumber,
    String? avatarPath,
  }) async {
    final url = Uri.parse("$_baseUrl/auth/profile");
    final headers = await _getHeaders();
    
    Map<String, dynamic> data = {
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (bio != null) "bio": bio,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (avatarPath != null) "avatar": avatarPath,
    };

    return await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );
  }

  Future<http.Response> enrollCourse(String courseId) async {
    final url = Uri.parse("$_baseUrl/auth/enrollments/$courseId");
    final headers = await _getHeaders();
    return await http.post(url, headers: headers);
  }

  Future<http.Response> getCourseLessons(String courseId) async {
    final url = Uri.parse("$_baseUrl/auth/courses/$courseId/lessons");
    final headers = await _getHeaders();
    return await http.get(url, headers: headers);
  }

  Future<http.Response> completeLesson(String lessonId) async {
    final url = Uri.parse("$_baseUrl/auth/lessons/$lessonId/complete");
    final headers = await _getHeaders();
    return await http.post(url, headers: headers);
  }

  Future<http.Response> getProfile([String? token]) async {
    final url = Uri.parse("$_baseUrl/auth/profile");
    final headers = await _getHeaders(token);
    return await http.get(url, headers: headers);
  }
}
