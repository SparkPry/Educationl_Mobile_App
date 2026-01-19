import 'package:education_app/models/category.dart';
import '../models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:education_app/widgets/course_card.dart';
import '../data/course_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            SliverToBoxAdapter(child: _buildSectionTitle("Popular Courses")),
              _buildPopularCourses(),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildSectionTitle("Top Rated")),
            _buildTopRatedCourses(),
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
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good morning", style: TextStyle(color: Colors.grey)),
              Text("John Doe",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF6B66FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("TODAY SPECIAL",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text("75% OFF",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32)),
                SizedBox(height: 4),
                Text("Get a special discount for your first course",
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: List.generate(
                3,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0
                            ? Colors.white
                            : Colors.white.withAlpha((255 * 0.5).round()),
                        shape: BoxShape.circle,
                      ),
                    )),
          )
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      Category(name: "Design", icon: Icons.design_services),
      Category(name: "Programming", icon: Icons.code),
      Category(name: "Health & Fitness", icon: Icons.health_and_safety),
      Category(name: "More", icon: Icons.more_horiz),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              if (category.name == "More") {
                Navigator.pushNamed(context, '/category');
              }
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE8E8FF),
                  child: Icon(category.icon, color: const Color(0xFF6B66FF)),
                ),
                const SizedBox(height: 8),
                Text(category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Widget _buildPopularCourses() {
    final courses = courseData;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 16 * 3) / 2;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: cardWidth / 0.7 + 32, // Calculated height based on aspect ratio
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return SizedBox(
              width: cardWidth,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/course', arguments: course);
                },
                child: CourseCard(
                  course: course,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopRatedCourses() {
    final courses = courseData;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final course = courses[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/course', arguments: course);
              },
              child: CourseCard(
                course: course,
              ),
            );
          },
          childCount: courses.length,
        ),
      ),
    );
  }

  Widget _buildMentorSection() {
    final mentors = [
      {"name": "Alice", "avatar": "assets/images/mentor1.jpg"},
      {"name": "Bob", "avatar": "assets/images/mentor2.jpg"},
      {"name": "Charlie", "avatar": "assets/images/mentor3.jpg"},
      {"name": "Diana", "avatar": "assets/images/mentor4.jpg"},
      {"name": "Eve", "avatar": "assets/images/mentor5.jpg"},
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: mentors.map((mentor) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(mentor["avatar"] as String),
                ),
                const SizedBox(height: 8),
                Text(mentor["name"] as String,
                    style: const TextStyle(fontSize: 12)),
              ],
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
      selectedItemColor: const Color(0xFF6B66FF),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined), label: "My Courses"),
        BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined), label: "Inbox"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}

