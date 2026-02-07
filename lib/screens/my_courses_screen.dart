import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';

import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';

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

  // ---------- API DATA ----------
  List<Course> _apiCourses = [];
  List<Course> _filteredCourses = [];
  bool _isLoadingApi = true;

  // ---------- FILTER STATE ----------
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';

  static const List<String> _tabTitles = ['Course', 'Ongoing', 'Completed'];

  // ---------- MOCK DATA ----------
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

      if (!mounted) return;

      final mapped = apiCourses.map(_mapApiToCourse).toList();

      setState(() {
        _apiCourses = mapped;
        _filteredCourses = mapped; // 👈 initial = all
        _isLoadingApi = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingApi = false);
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
      progress: null,
    );
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

  // ================= DATA SWITCH =================

  List<Course> get _currentCourses {
    switch (_selectedTabIndex) {
      case 0:
        return _filteredCourses; // ✅ FILTERED API
      case 1:
        return _ongoingCourses;
      case 2:
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
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, index) =>
                            _CourseCard(course: _currentCourses[index]),
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
                backgroundColor: AppColors.primaryColor,
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

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/course', arguments: course),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: course.image.startsWith('http')
                  ? Image.network(
                      course.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      course.image,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
