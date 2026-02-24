import 'dart:async';
import 'package:flutter/material.dart';
import 'package:education_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:education_app/models/category.dart';
import 'package:education_app/models/mentor_model.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/inbox_screen.dart';
import 'package:education_app/screens/student_profile_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/mentor_profile_screen.dart';
import 'package:education_app/utils/app_colors.dart';

import 'package:education_app/widgets/course_card.dart';
import '../models/course_model.dart';
import '../models/api_course.dart';
import '../services/course_api_service.dart';

class _PromoBannerData {
  final String image;

  _PromoBannerData({
    required this.image,
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
  List<Course> _courses = [];
  List<Course> _topRatedSnapshot = [];

  bool _isLoadingCourses = true;

  final List<_PromoBannerData> _promoBanners = [
    _PromoBannerData(image: "assets/images/banner1.jpg"),
    _PromoBannerData(image: "assets/images/banner2.jpg"),
    _PromoBannerData(image: "assets/images/banner3.jpg"),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < _promoBanners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
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

      if (!mounted) return;

      // 1️⃣ Map API → Course ONCE
      final List<Course> mappedCourses = apiCourses.map((api) {
        return Course(
          id: api.id.toString(),
          slug: api.title.toLowerCase().replaceAll(' ', '-'),
          title: api.title,
          category: api.category,
          description: api.longDescription,
          duration: api.duration,
          rating: 4.5, // mock
          image: api.thumbnail,
          price: api.discountPrice ?? api.price,
          level: api.level,
          overview: Overview(
            about: [api.longDescription],
            learn: [],
            requirements: [],
            forWho: [],
          ),
          curriculum: [],
          instructor: Instructor(
            name: 'AngkorEdu',
            title: 'Teacher',
            avatar:
                'https://i.pinimg.com/736x/b7/31/2b/b7312b36fa5139575f8cff445780c849.jpg',
            bio: '',
          ),
          reviews: Reviews(total: 0, average: 4.5),
        );
      }).toList();
      final shuffled = List<Course>.from(mappedCourses)..shuffle();
      final randomFour = shuffled.length > 4
          ? shuffled.take(4).toList()
          : shuffled;

      setState(() {
        _courses = mappedCourses;
        _topRatedSnapshot = randomFour;
        _isLoadingCourses = false;
      });
    } catch (e) {
      if (!mounted) return;
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
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyCoursesScreen()),
        );
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
          MaterialPageRoute(builder: (context) => ProfileScreen()),
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
            SliverToBoxAdapter(child: _buildHeader(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildPromoBanner()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildCategories(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: _buildSectionTitle(
                "Popular Courses",
                onSeeAll: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MyCoursesScreen()),
                  );
                },
              ),
            ),
            _buildPopularCourses(context),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSectionTitle("Top Rated")),
            _buildTopRatedCourses(context),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSectionTitle("Our Mentors")),
            _buildMentorSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StudentProfileScreen(student: user)),
                  );
                },
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: ClipOval(
                    child: user.avatar.startsWith('assets/')
                        ? Image.asset(
                            user.avatar,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )
                        : Image.network(
                            user.avatar,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Good morning", style: TextStyle(color: Colors.grey)),
                  Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  Navigator.pushNamed(context, '/filter');
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  Navigator.pushNamed(context, '/notification');
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _promoBanners.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _PromoBannerCard(data: _promoBanners[index]);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promoBanners.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primaryColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      Category(name: "Web", icon: Icons.design_services),
      Category(name: "Programming", icon: Icons.code),
      Category(name: "Database", icon: Icons.health_and_safety),
      Category(name: "More", icon: Icons.more_horiz),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/myCourses',
                arguments: category.name,
              );
              if (category.name == "More") {
                Navigator.pushNamed(context, '/category');
              }
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE8E8FF),
                  child: Icon(category.icon, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF6B66FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
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
    final popularCourses = _courses.length > 4
        ? _courses.take(4).toList()
        : _courses;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 16 * 3) / 2;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: cardWidth / 0.7 + 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: popularCourses.length,
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

    if (_topRatedSnapshot.isEmpty) {
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
          final course = _topRatedSnapshot[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/course', arguments: course);
            },
            child: CourseCard(course: course),
          );
        }, childCount: _topRatedSnapshot.length),
      ),
    );
  }

  Widget _buildMentorSection() {
    final mentors = [
      {"name": "Alice", "avatar": "assets/images/Alice.jpg"},
      {"name": "Bob", "avatar": "assets/images/Bob.jpg"},
      {"name": "Charlie", "avatar": "assets/images/Charlie.jpg"},
      {"name": "Diana", "avatar": "assets/images/Diana.jpg"},
      {"name": "Eve", "avatar": "assets/images/Eve.jpg"},
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: mentors.map((mentorData) {
            return GestureDetector(
              onTap: () {
                final mentor = Mentor(
                  name: mentorData["name"]!,
                  profileImage: mentorData["avatar"]!,
                  title: "Senior Product Designer",
                  about:
                      "Experienced mentor with a passion for teaching and helping students achieve their goals in the field of design and technology. I have over 10 years of experience in the industry and have worked with several top-tier companies.",
                  courses: ["UI/UX Design", "Graphic Design", "Web Design"],
                  students: "1,250",
                  rating: "4.8",
                  reviewsCount: "450",
                  reviews: [
                    MentorReview(
                      userName: "Alex Johnson",
                      comment: "Amazing mentor! Really helped me understand the core concepts of UI/UX.",
                      rating: 5.0,
                      date: "2 days ago",
                    ),
                    MentorReview(
                      userName: "Sarah Williams",
                      comment: "The courses are well-structured and easy to follow.",
                      rating: 4.5,
                      date: "1 week ago",
                    ),
                  ],
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MentorProfileScreen(mentor: mentor),
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 60, // 2 * radius
                    height: 60, // 2 * radius
                    child: ClipOval(
                      child: Image.asset(
                        mentorData["avatar"]!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mentorData["name"]!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
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
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Courses"),
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(data.image),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
