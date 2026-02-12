import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_course.dart';

class CourseApiService {
  static const String _baseUrl =
      'https://e-learning-api-production-a6d4.up.railway.app';

  static Future<List<ApiCourse>> fetchCourses(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/courses'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ApiCourse.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchLessons({
    required String token,
    required String courseId,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/api/courses/$courseId/lessons'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      // Only return id, title, content
      return data.map<Map<String, dynamic>>((lesson) {
        return {
          'id': lesson['id'],
          'title': lesson['title'],
          'content': lesson['content'],
          'completed': lesson['completed'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load lessons');
    }
  }
}
