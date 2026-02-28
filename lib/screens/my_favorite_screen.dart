import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:education_app/providers/user_provider.dart';
import 'package:education_app/data/course_data.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:education_app/widgets/course_card.dart'; // We can reuse this or create a new one

class MyFavoriteScreen extends StatelessWidget {
  const MyFavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // This logic assumes you have a way to get the full course details from their IDs.
          // For this example, we'll filter the global `courseData` list.
          final favoriteCourses = courseData
              .where((course) =>
                  userProvider.user.favoriteCourseIds.contains(course.id))
              .toList();

          if (favoriteCourses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Favorites Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the heart on any course to add it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }

          // Using a GridView for a more visually appealing layout
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 courses per row
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7, // Adjust this ratio for desired card height
            ),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];
              // We can reuse the existing CourseCard and wrap it to remove default margins
              return CourseCard(course: course);
            },
          );
        },
      ),
    );
  }
}
