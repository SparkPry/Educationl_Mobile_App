import 'package:flutter/material.dart';
import 'package:education_app/models/user_model.dart';
import 'package:education_app/screens/student_profile_screen.dart';
import 'package:education_app/utils/app_colors.dart';

class FindFriendsScreen extends StatelessWidget {
  const FindFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate 10 random student names
    final List<String> studentNames = [
      'Liam Smith',
      'Noah Williams',
      'Oliver Brown',
      'James Jones',
      'Elijah Garcia',
      'William Miller',
      'Henry Davis',
      'Lucas Rodriguez',
      'Benjamin Martinez',
      'Theodore Hernandez',
    ];

    // Create 10 mock UserModel objects
    final List<UserModel> students = List.generate(10, (index) {
      return UserModel(
        name: studentNames[index],
        email: '${studentNames[index].toLowerCase().replaceAll(' ', '.')}@example.com',
        avatar: 'assets/images/John Doe.jpg',
        bio: 'Hello! I am a student at the Education App. I love learning new things and making new friends!',
        joinDate: 'Mar 2024',
        coursesCompleted: (index + 1) * 2,
        learningHours: (index + 1) * 15,
        enrolledCourseNames: [
          'Course ${index + 1}A',
          'Course ${index + 1}B',
        ],
        certificates: [],
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Find Friends', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: Icon(Icons.person, size: 30, color: Colors.grey.shade600),
            ),
            title: Text(
              student.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(student.email, style: TextStyle(color: Colors.grey.shade600)),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_add, color: AppColors.primaryColor, size: 20),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfileScreen(student: student),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
