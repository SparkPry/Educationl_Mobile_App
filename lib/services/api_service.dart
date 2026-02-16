import 'package:dio/dio.dart';
// import '../models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://e-learning-api-production-a6d4.up.railway.app/api",
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }

  // Future<List<Course>> getCourses() async {
  //   final response = await dio.get("/courses");

  //   List data = response.data;

  //   return data.map((json) => Course.fromJson(json)).toList();
  // }

  Future<Response> login(String email, String password) async {
    return await dio.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );
  }

  Future<Response> register(String name, String email, String password) async {
    return await dio.post(
      "/auth/register",
      data: {"name": name, "email": email, "password": password},
    );
  }
}
