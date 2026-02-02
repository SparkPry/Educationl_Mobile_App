import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/learning_screen.dart';

import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:education_app/models/course_model.dart'; // Import Course model
import 'package:education_app/data/course_data.dart'; // Import global course data

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedTabIndex = 0; // Default to 'About' tab

  static const List<String> _tabTitles = ['About', 'Ongoing', 'Completed'];

  List<Course> get _ongoingCourses => courseData
      .where(
        (course) =>
            course.progress != null &&
            course.progress! > 0 &&
            course.progress! < 1.0,
      )
      .toList();

  List<Course> get _completedCourses => courseData
      .where((course) => course.progress != null && course.progress! == 1.0)
      .toList();

  List<Course> get _currentCourses {
    switch (_selectedTabIndex) {
      case 0: // About
        // For "About" tab, return all courses but with progress set to null
        return courseData
            .map(
              (course) => Course(
                id: course.id,
                slug: course.slug,
                title: course.title,
                category: course.category,
                description: course.description,
                duration: course.duration,
                rating: course.rating,
                image: course.image,
                price: course.price,
                overview: course.overview,
                curriculum: course.curriculum,
                instructor: course.instructor,
                reviews: course.reviews,
                progress:
                    null, // Explicitly set progress to null for "About" tab
              ),
            )
            .toList();
      case 1: // Ongoing
        return _ongoingCourses;
      case 2: // Completed
        return _completedCourses;
      default:
        return [];
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'My Courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabTitles.length, (index) {
                return GestureDetector(
                  onTap: () => _onTabTapped(index),
                  child: _TabItem(
                    title: _tabTitles[index],
                    isActive: _selectedTabIndex == index,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Course List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _currentCourses.length,
              separatorBuilder: (context, index) => Column(
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(height: 1, color: Colors.grey.shade300),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              itemBuilder: (context, index) {
                final course = _currentCourses[index];
                return _CourseCard(
                  course: course, // Pass the Course object directly
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1:
              // Current screen, do nothing
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const InboxScreen()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}

// -------------------- TAB ITEM --------------------

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primaryColor : Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        if (isActive)
          Container(
            width: 20,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }
}

// -------------------- COURSE CARD --------------------

class _CourseCard extends StatelessWidget {
  final Course course; // Change to accept Course object

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final bool showProgress = course.progress != null && course.progress! > 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LearningScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Avatar Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha((255 * 0.1).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              // Directly use Image.asset here
              child: Image.asset(
                course.image, // Use course image
                fit: BoxFit.cover,
                alignment: Alignment.center, // Center the course image
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to initials if image fails
                  return Center(
                    child: Text(
                      course.title
                          .split(' ')
                          .map((e) => e[0])
                          .join(), // Initials from course title
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 24,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Text Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title, // Use course title
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        course.instructor.name, // Use instructor name
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '|',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        course.category, // Use course category
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                  if (showProgress) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(course.progress! * 100).round()}%', // Use course progress
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Roboto',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: course.progress, // Use course progress
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
