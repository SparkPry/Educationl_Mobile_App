import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/services/api_service.dart';
import 'package:dio/dio.dart';

class EReceiptScreen extends StatefulWidget {
  final Course course;
  final String userName;
  final String userEmail;

  const EReceiptScreen({
    super.key,
    required this.course,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<EReceiptScreen> createState() => _EReceiptScreenState();
}

class _EReceiptScreenState extends State<EReceiptScreen> {
  final ApiService _apiService = ApiService();

  String? _date;
  String? _time;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateFormat('dd.MM.yy').format(now);
    _time = DateFormat('HH:mm').format(now);
  }

  void _showDialog({
    required String message,
    bool goHome = false,
    bool goToOngoing = false,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Notice"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                if (goHome) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                } else if (goToOngoing) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyCoursesScreen(initialTabIndex: 1),
                    ),
                    (route) => false,
                  );
                }
              },
              child: const Text("Go To Course"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleEnroll() async {
    final courseId = widget.course.id;

    setState(() => _isLoading = true);

    try {
      await _apiService.enrollCourse(courseId);

      setState(() => _isLoading = false);

      _showDialog(
        message: "You've been enrolled in the course successfully 🎉🎉🎉🎉🎉",
        goToOngoing: true,
      );
    } on DioException catch (e) {
      setState(() => _isLoading = false);

      if (e.response?.statusCode == 400 || e.response?.statusCode == 409) {
        _showDialog(
          message: "You've already enrolled in this course 🔙🔙🔙🔙🔙",
          goToOngoing: true,
        );
      } else {
        _showDialog(
          message: "Something went wrong. Please try again.",
          goHome: true,
        );
      }
    } catch (_) {
      setState(() => _isLoading = false);
      _showDialog(message: "Unexpected error occurred.", goHome: true);
    }
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: const Color.fromARGB(255, 86, 39, 216),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('E-receipt'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= COURSE INFO =================
                    const Text(
                      'Course Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Course Name', course.title),
                    _buildInfoRow('Category', course.category),
                    _buildInfoRow('Mentor', course.instructor.name),
                    const Divider(height: 30),

                    // ================= STUDENT INFO =================
                    const Text(
                      'Student Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Student', widget.userName),
                    _buildInfoRow('Email', widget.userEmail),
                    _buildInfoRow('Phone', '855+ 0876543678'),
                    _buildInfoRow('Country', 'Cambodia'),
                    const Divider(height: 30),

                    // ================= PAYMENT INFO =================
                    const Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Price',
                      '\$${course.discountPrice ?? course.price}',
                    ),
                    _buildInfoRow('Payment method', 'Paypal'),
                    _buildInfoRow('Date', _date ?? ''),
                    _buildInfoRow('Time', _time ?? ''),
                    _buildInfoRow(
                      'Status',
                      'Pending',
                      valueColor: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= ENROLL BUTTON =================
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ================= DOWNLOAD BUTTON =================
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add real download logic later
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("E-receipt downloaded successfully"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Download E-receipt",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                // ================= ENROLL BUTTON =================
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEnroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Enroll Course',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
