import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';

import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/learning_screen.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/services/course_api_service.dart';
import '../services/api_service.dart';

class MyCoursesScreen extends StatefulWidget {
  final String? initialCategory;
  final int initialTabIndex;

  const MyCoursesScreen({
    super.key,
    this.initialCategory,
    this.initialTabIndex = 0, // default = All Course
  });

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  int _selectedTabIndex = 0;
  final ApiService _apiService = ApiService();
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzY5Njc2MTg4LCJleHAiOjE3Njk3NjI1ODh9.k-wd4sHo-ZXIC02mPFl5lUhSF-dtpYoF9tHeC92iyWs';

  // ---------- API DATA ----------
  List<Course> _apiCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoadingApi = true;

  static const List<String> _tabTitles = ['All Course', 'Ongoing', 'Completed'];

  List<Course> get _currentCourses {
    switch (_selectedTabIndex) {
      case 0:
        return _filteredCourses.isEmpty ? _apiCourses : _filteredCourses;

      case 1: // Ongoing
        return _apiCourses
            .where((course) => course.isEnrolled && course.progress < 1)
            .toList();

      case 2: // Completed
        return _apiCourses.where((course) => course.progress == 1).toList();

      default:
        return [];
    }
  }
  // ================= API =================

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _loadApiCourses();
  }

  Future<void> _loadApiCourses() async {
    try {
      final apiCourses = await CourseApiService.fetchCourses(_token);

      final mapped = apiCourses.map((api) {
        return Course(
          id: api.id.toString(),
          slug: api.slug,
          title: api.title,
          category: api.category,
          description: api.description,
          duration: api.duration,
          rating: 4.5,
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
            name: 'AngkorEdu',
            title: 'Teacher',
            avatar: 'assets/images/Logo.jpg',
            bio: '',
          ),
          reviews: Reviews(total: 0, average: 4.5),
        );
      }).toList();
      for (var course in mapped) {
        try {
          final lessonResponse = await _apiService.getCourseLessons(course.id);

          final lessons = lessonResponse.data as List;

          course.isEnrolled = true;

          if (lessons.isNotEmpty) {
            final completedLessons = lessons
                .where((l) => l["completed"] == 1)
                .length;

            course.progress = completedLessons / lessons.length;
          } else {
            course.progress = 0.0;
          }
        } catch (e) {
          // Not enrolled (API likely returns 403)
          course.isEnrolled = false;
          course.progress = 0.0;
        }
      }
      if (!mounted) return;

      setState(() {
        _apiCourses = mapped;
        _filteredCourses = mapped;
        _isLoadingApi = false;
      });
      if (widget.initialCategory != null) {
        _applyFilter(category: widget.initialCategory!, level: 'All');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingApi = false);
    }
  }

  // ================= FILTER LOGIC =================

  void _applyFilter({required String category, required String level}) {
    List<Course> result = _apiCourses;

    if (category != 'All') {
      result = result.where((course) {
        return course.category.toLowerCase() == category.toLowerCase();
      }).toList();
    }

    if (level != 'All') {
      result = result.where((course) {
        return course.level.toLowerCase() == level.toLowerCase();
      }).toList();
    }

    setState(() {
      _filteredCourses = result;
    });
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
          'Courses',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
                child: _isLoadingApi && _selectedTabIndex == 0
                    ? const Center(child: CircularProgressIndicator())
                    : _currentCourses.isEmpty
                    ? const Center(
                        child: Text(
                          'No courses available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentCourses.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (_, index) {
                          final course = _currentCourses[index];

                          return GestureDetector(
                            onTap: () async {
                              if (_selectedTabIndex == 0) {
                                // ✅ All Course → CourseScreen
                                Navigator.pushNamed(
                                  context,
                                  '/course',
                                  arguments: course,
                                );
                              } else {
                                // ✅ Ongoing → LearningScreen
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LearningScreen(course: course),
                                  ),
                                );

                                if (result == true) {
                                  _loadApiCourses(); // 🔥 reload everything
                                }
                              }
                            },
                            child: _CourseCard(
                              course: course,
                              showProgress: _selectedTabIndex != 0,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),

          // ---------- FILTER BUTTON ----------
          if (_selectedTabIndex == 0)
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 178, 176, 250),
                child: const Icon(Icons.filter_list),
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, '/filter');

                  if (result is Map) {
                    _applyFilter(
                      category: result['category'] ?? 'All',
                      level: result['level'] ?? 'All',
                    );
                  }
                },
              ),
            ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Courses',
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
            color: isActive ? AppColors.primaryColor : Colors.grey,
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
  final bool showProgress;

  const _CourseCard({required this.course, required this.showProgress});

  Widget _courseImage() {
    if (course.image.startsWith('http')) {
      return Image.network(
        course.image,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    }

    return Image.asset(course.image, width: 64, height: 64, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _courseImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${course.instructor.name} | ${course.category}',
                  style: const TextStyle(color: Colors.grey),
                ),

                // 🔥 Only show progress when allowed
                if (showProgress) ...[
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: course.progress, minHeight: 6),
                  const SizedBox(height: 4),
                  Text(
                    '${(course.progress * 100).round()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
