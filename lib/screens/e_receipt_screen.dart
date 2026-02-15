import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/screens/learning_screen.dart';

class EReceiptScreen extends StatefulWidget {
  final Course course;

  const EReceiptScreen({super.key, required this.course});

  @override
  State<EReceiptScreen> createState() => _EReceiptScreenState();
}

class _EReceiptScreenState extends State<EReceiptScreen> {
  String? _date;
  String? _time;

  final Set<String> _completedCourseIds = {
    '16',
  }; // adjust to your real completed
  void _showDialog({
    required String message,
    bool goHome = false,
    bool goToOngoing = false,
    bool goToLearning = false,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        String buttonText = "OK";

        if (goHome) {
          buttonText = "Go Back";
        } else if (goToLearning) {
          buttonText = "Go to Learning Screen";
        } else if (goToOngoing) {
          buttonText = "Go to Course";
        }

        return AlertDialog(
          title: const Text("Notice"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog first

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
                } else if (goToLearning) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningScreen(course: widget.course),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateFormat('dd.MM.yy').format(now);
    _time = DateFormat('HH:mm').format(now);
  }

  // Helper widget to build a row for information display
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('E-receipt'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // No shadow for the AppBar
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Course Info
                    Text(
                      'Course Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Course Name', widget.course.title),
                    _buildInfoRow('Category', widget.course.category),
                    _buildInfoRow('Mentor', 'AngkorEdu'),
                    const Divider(
                      height: 30,
                      thickness: 1,
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),

                    // Section 2: Student Info
                    Text(
                      'Student Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow('Student', 'Sopheap'),
                    _buildInfoRow('Email', 'sopheap@gmail.com'),
                    _buildInfoRow('Phone', '855+ 0876543678'),
                    _buildInfoRow('Country', 'Cambodia'),
                    const Divider(
                      height: 30,
                      thickness: 1,
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),

                    // Section 3: Payment Info
                    Text(
                      'Payment Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Price',
                      '\$${widget.course.discountPrice ?? widget.course.price}',
                    ),
                    _buildInfoRow('Payment method', 'Paypal'),
                    _buildInfoRow('Date', _date ?? ''),
                    _buildInfoRow('Time', _time ?? ''),
                    _buildInfoRow('Status', 'Unpaid', valueColor: Colors.blue),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Download e-receipt logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors.primaryColor, // Purple/Indigo color
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Download e-receipt',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final courseId = widget.course.id.toString();

                      // Already completed
                      if (_completedCourseIds.contains(courseId)) {
                        _showDialog(
                          message: "You've already completed this course ❌❌❌❌❌",
                          goToOngoing: true,
                        );
                        return;
                      }

                      // Already enrolled
                      if (MyCoursesScreen.ongoingCourseIds.contains(courseId)) {
                        _showDialog(
                          message:
                              "You've already enrolled in this course 🔙🔙🔙🔙🔙",
                          goHome: true,
                        );
                        return;
                      }

                      // ✅ NEW ENROLLMENT
                      MyCoursesScreen.ongoingCourseIds.add(courseId);

                      _showDialog(
                        message:
                            "You've been enrolled in the course successfully 🎉🎉🎉🎉🎉",
                        goToOngoing: true,
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors
                          .primaryColor, // Matching the Download e-receipt button
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Enroll Course',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
