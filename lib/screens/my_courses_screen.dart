import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';

import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/learning_screen.dart';

import 'package:education_app/models/course_model.dart';
import 'package:education_app/models/api_course.dart';
import 'package:education_app/services/course_api_service.dart';
import 'package:education_app/data/course_data.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedTabIndex = 0;

  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzY5Njc2MTg4LCJleHAiOjE3Njk3NjI1ODh9.k-wd4sHo-ZXIC02mPFl5lUhSF-dtpYoF9tHeC92iyWs';

  bool _isLoadingApi = true;
  List<Course> _apiCourses = [];

  static const List<String> _tabTitles = ['Course', 'Ongoing', 'Completed'];

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

  @override
  void initState() {
    super.initState();
    _loadApiCourses();
  }

  // ================= API =================

  Future<void> _loadApiCourses() async {
    try {
      final apiCourses = await CourseApiService.fetchCourses(_token);

      setState(() {
        _apiCourses = apiCourses.map(_mapApiToCourse).toList();
        _isLoadingApi = false;
      });
    } catch (_) {
      _isLoadingApi = false;
    }
  }

  Course _mapApiToCourse(ApiCourse api) {
    return Course(
      id: api.id.toString(),
      slug: api.slug,
      title: api.title,
      category: api.category,
      description: api.description,
      duration: api.duration,
      rating: 4.6,
      image: api.thumbnail,
      price: api.discountPrice ?? api.price,
      level: api.level,
      overview: Overview(
        about: [api.longDescription],
        learn: const [],
        requirements: const [],
        forWho: const [],
      ),
      curriculum: const [],
      instructor: Instructor(
        name: 'Instructor',
        title: api.category,
        avatar: 'assets/images/mentor1.jpg',
        bio: '',
      ),
      reviews: Reviews(total: 0, average: 4.6),
      progress: null, // IMPORTANT
    );
  }

  // ================= DATA SWITCH =================

  List<Course> get _currentCourses {
    switch (_selectedTabIndex) {
      case 0:
        return _apiCourses;
      case 1: // Ongoing
        return _ongoingCourses;
      case 2: // Completed
        return _completedCourses;
      default:
        return [];
    }
  }

  void _onTabTapped(int index) {
    setState(() => _selectedTabIndex = index);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'My Courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      // icon bottom
      body: Stack(
        children: [
          Column(
            children: [
              // ---- EXISTING BODY CONTENT (UNCHANGED) ----
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
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

              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _currentCourses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final course = _currentCourses[index];
                    return _CourseCard(course: course);
                  },
                ),
              ),
            ],
          ),

          // 👇 FILTER BUTTON (ONLY FOR COURSE TAB)
          if (_selectedTabIndex == 0)
            Positioned(
              right: 20,
              bottom: 20, // above bottom nav
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/filter');
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 53, 147, 160),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: AppColors.primaryColor,
                    size: 40,
                  ),
                ),
              ),
            ),
        ],
      ),

      // ---------- BOTTOM NAV ----------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
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
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const InboxScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

// ================= TAB ITEM =================

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primaryColor : Colors.grey.shade700,
            fontSize: 16,
            fontWeight: FontWeight.w500,
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

// ================= COURSE CARD =================

class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final bool showProgress = course.progress != null && course.progress! > 0;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/course', arguments: course);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // ---------- IMAGE (API + MOCK SAFE) ----------
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryColor.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: course.image.startsWith('http')
                    ? Image.network(
                        course.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(course),
                      )
                    : Image.asset(
                        course.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imageFallback(course),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // ---------- TEXT ----------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${course.instructor.name} | ${course.category}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  // ---------- PROGRESS (MOCK ONLY) ----------
                  if (showProgress) ...[
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: course.progress,
                      minHeight: 6,
                      color: AppColors.primaryColor,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- FALLBACK ----------
  Widget _imageFallback(Course course) {
    return Center(
      child: Text(
        course.title.split(' ').map((e) => e[0]).take(2).join(),
        style: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
