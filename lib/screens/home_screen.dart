import 'dart:async';
import 'package:flutter/material.dart';
import 'package:education_app/models/category.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:education_app/widgets/course_card.dart';

import '../models/course_model.dart';
import '../models/api_course.dart';
import '../services/course_api_service.dart';

class _PromoBannerData {
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  _PromoBannerData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  int _currentPage = 0;
  late final Timer _timer;
  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzY5Njc2MTg4LCJleHAiOjE3Njk3NjI1ODh9.k-wd4sHo-ZXIC02mPFl5lUhSF-dtpYoF9tHeC92iyWs';

  // 🔑 REAL DATA replaces courseData
  List<Course> _courses = [];
  bool _isLoadingCourses = true;

  final List<_PromoBannerData> _promoBanners = [
    _PromoBannerData(
      title: "TODAY SPECIAL",
      subtitle: "75% OFF",
      description: "Get a special discount for your first course",
      color: AppColors.primaryColor,
    ),
    _PromoBannerData(
      title: "NEW COURSES",
      subtitle: "50% OFF",
      description: "Explore our latest courses and get a discount",
      color: const Color(0xFFE8505B),
    ),
    _PromoBannerData(
      title: "SUMMER SALE",
      subtitle: "30% OFF",
      description: "Get ready for summer with our special offers",
      color: const Color(0xFFF9A825),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % _promoBanners.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final List<ApiCourse> apiCourses = await CourseApiService.fetchCourses(
        _token,
      );

      setState(() {
        _courses = apiCourses.map((api) {
          return Course(
            id: api.id.toString(),
            slug: api.title.toLowerCase().replaceAll(' ', '-'),
            title: api.title,
            category: api.category,
            description: api.longDescription,
            duration: api.duration,
            rating: 4.5,
            image: api.thumbnail,
            price: api.discountPrice ?? api.price,
            overview: Overview(
              about: [],
              learn: [],
              requirements: [],
              forWho: [],
            ),
            curriculum: [],
            instructor: Instructor(
              name: 'Instructor',
              title: 'Teacher',
              avatar: 'assets/images/mentor1.jpg',
              bio: '',
            ),
            reviews: Reviews(total: 0, average: 4.5),
          );
        }).toList();

        _isLoadingCourses = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCourses = false;
      });
      debugPrint('API ERROR: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InboxScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildCategories()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSectionTitle("Popular Courses")),
            _buildPopularCourses(context),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSectionTitle("Top Rated")),
            _buildTopRatedCourses(context),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 24),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good morning", style: TextStyle(color: Colors.grey)),
              Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _promoBanners.length,
        itemBuilder: (_, index) => _PromoBannerCard(data: _promoBanners[index]),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      Category(name: "Design", icon: Icons.design_services),
      Category(name: "Programming", icon: Icons.code),
      Category(name: "Health & Fitness", icon: Icons.health_and_safety),
      Category(name: "More", icon: Icons.more_horiz),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((c) {
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE8E8FF),
                child: Icon(c.icon, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 8),
              Text(c.name, style: const TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildPopularCourses(BuildContext context) {
    if (_isLoadingCourses) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_courses.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Courses are temporarily unavailable',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 16 * 3) / 2;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: cardWidth / 0.7 + 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return SizedBox(
              width: cardWidth,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/course', arguments: course);
                },
                child: CourseCard(course: course),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopRatedCourses(BuildContext context) {
    if (_isLoadingCourses) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_courses.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Courses are temporarily unavailable',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final course = _courses[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/course', arguments: course);
            },
            child: CourseCard(course: course),
          );
        }, childCount: _courses.length),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: "My Courses",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: "Inbox"),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}

class _PromoBannerCard extends StatelessWidget {
  final _PromoBannerData data;

  const _PromoBannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          Text(data.description, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
