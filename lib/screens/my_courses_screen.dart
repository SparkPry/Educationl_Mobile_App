import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

// A simple data model for the course examples
class _CourseData {
  final String title;
  final String instructor;
  final String category;
  final String initials; // Changed from IconData to String
  final double? progress; // Added for progress tracking (now nullable)

  const _CourseData({
    required this.title,
    required this.instructor,
    required this.category,
    required this.initials, // Updated parameter
    this.progress, // New parameter, now optional
  });
}

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedTabIndex = 0; // Default to 'About' tab

  static const List<String> _tabTitles = ['About', 'Ongoing', 'Completed'];

  // Example course data for Ongoing tab based on the user's request
  static const List<_CourseData> _ongoingCourses = [
    _CourseData(
      title: 'Java Script',
      instructor: 'Dr. Kendy',
      category: 'Programming',
      initials: 'JS',
      progress: 0.95, // 95%
    ),
    _CourseData(
      title: 'Graphic Design',
      instructor: 'Mrs William',
      category: 'Design',
      initials: 'GW',
      progress: 0.60, // 60%
    ),
    _CourseData(
      title: 'UI/UX Design',
      instructor: 'Mr. Alex',
      category: 'Design',
      initials: 'UA',
      progress: 0.30, // 30%
    ),
  ];

  // Example course data for About tab (for demonstration, can be expanded)
  static const List<_CourseData> _aboutCourses = [
    _CourseData(
      title: 'Introduction to Flutter',
      instructor: 'Dr. Sarah',
      category: 'Mobile Dev',
      initials: 'SF',
      progress: null, // No progress for About tab
    ),
    _CourseData(
      title: 'Web Development Basics',
      instructor: 'Mr. David',
      category: 'Web Dev',
      initials: 'DW',
      progress: null, // No progress for About tab
    ),
    _CourseData(
      title: 'Data Science Fundamentals',
      instructor: 'Ms. Emily',
      category: 'Data Science',
      initials: 'ED',
      progress: null, // No progress for About tab
    ),
    _CourseData(
      title: 'Digital Marketing Strategy',
      instructor: 'Dr. Chris',
      category: 'Marketing',
      initials: 'CM',
      progress: null, // No progress for About tab
    ),
  ];

  // Example course data for Completed tab (for demonstration, can be expanded)
  static const List<_CourseData> _completedCourses = [
    _CourseData(
      title: 'Completed Course A',
      instructor: 'Dr. White',
      category: 'Science',
      initials: 'DW',
      progress: 1.0,
    ),
    _CourseData(
      title: 'Advanced React',
      instructor: 'Ms. Lisa',
      category: 'Programming',
      initials: 'LR',
      progress: 1.0,
    ),
  ];

  List<_CourseData> get _currentCourses {
    switch (_selectedTabIndex) {
      case 0: // About
        return _aboutCourses;
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
                  title: course.title,
                  instructor: course.instructor,
                  category: course.category,
                  initials: course.initials,
                  progress: course.progress, // Pass null or actual progress
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
  final String title;
  final String instructor;
  final String category;
  final String initials;
  final double? progress; // Now nullable

  const _CourseCard({
    required this.title,
    required this.instructor,
    required this.category,
    required this.initials,
    this.progress, // Now optional
  });

  @override
  Widget build(BuildContext context) {
    final bool showProgress = progress != null && progress! > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Initials Container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(color: AppColors.primaryColor, fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                      instructor,
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
                      category,
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
                        '${(progress! * 100).round()}%',
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
                      value: progress,
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
    );
  }
}
