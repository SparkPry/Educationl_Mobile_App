import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildPromoBanner(),
              const SizedBox(height: 20),
              _buildCategories(),
              const SizedBox(height: 20),
              _buildSectionTitle("Popular Courses"),
              _buildPopularCourses(),
              const SizedBox(height: 20),
              _buildSectionTitle("Top Rated"),
              _buildTopRatedCourses(),
              const SizedBox(height: 20),
              _buildSectionTitle("Our Mentors"),
              _buildMentorSection(),
              const SizedBox(height: 50),
            ],
          ),
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
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good morning", style: TextStyle(color: Colors.grey)),
              Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/verification');
            },
            child: const Text('OTP'),
          )
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
                Text("TODAY SPECIAL", style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text("75% OFF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
                SizedBox(height: 4),
                Text("Get a special discount for your first course", style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: List.generate(3, (index) => Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == 0 ? Colors.white : Colors.white.withAlpha((255 * 0.5).round()),
                shape: BoxShape.circle,
              ),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {"icon": Icons.design_services, "label": "Design"},
      {"icon": Icons.code, "label": "Programming"},
      {"icon": Icons.health_and_safety, "label": "Health & \nFitness"},
      {"icon": Icons.more_horiz, "label": "More"},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories.map((category) {
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE8E8FF),
                child: Icon(category["icon"] as IconData, color: const Color(0xFF6B66FF)),
              ),
              const SizedBox(height: 8),
              Text(category["label"] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Widget _buildPopularCourses() {
    final courses = [
      {"image": "https://img.freepik.com/free-photo/3d-cartoon-style-character_23-2151034102.jpg", "title": "UI/UX Design Fundamentals", "rating": 4.8, "subscribers": "12.5k", "instructor": "John Doe", "category": "Design"},
      {"image": "https://img.freepik.com/free-psd/3d-illustration-business-statistics_23-2150933757.jpg", "title": "Advanced Dart & Flutter", "rating": 4.9, "subscribers": "20.1k", "instructor": "Jane Smith", "category": "Programming"},
    ];

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            imageUrl: course["image"] as String,
            title: course["title"] as String,
            rating: course["rating"] as double,
            subscribers: course["subscribers"] as String,
            instructor: course["instructor"] as String,
            category: course["category"] as String,
          );
        },
      ),
    );
  }

  Widget _buildTopRatedCourses() {
     final courses = [
      {"image": "https://img.freepik.com/free-photo/glowing-blue-sphere-held-by-human-hand-in-darkness_23-2151528643.jpg", "title": "Python for Data Science", "rating": 4.9, "subscribers": "18.2k", "instructor": "Emily White", "category": "Programming"},
      {"image": "https://img.freepik.com/free-photo/glowing-neon-sphere-held-by-human-hand_23-2151528666.jpg", "title": "Digital Marketing Masterclass", "rating": 4.7, "subscribers": "15.8k", "instructor": "David Green", "category": "Business"},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
           final course = courses[index];
          return CourseCard(
            imageUrl: course["image"] as String,
            title: course["title"] as String,
            rating: course["rating"] as double,
            subscribers: course["subscribers"] as String,
            instructor: course["instructor"] as String,
            category: course["category"] as String,
          );
        },
      ),
    );
  }

  Widget _buildMentorSection() {
    final mentors = [
      {"name": "Alice", "avatar": "https://i.pravatar.cc/150?img=1"},
      {"name": "Bob", "avatar": "https://i.pravatar.cc/150?img=2"},
      {"name": "Charlie", "avatar": "https://i.pravatar.cc/150?img=3"},
      {"name": "Diana", "avatar": "https://i.pravatar.cc/150?img=4"},
      {"name": "Eve", "avatar": "https://i.pravatar.cc/150?img=5"},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final mentor = mentors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(mentor["avatar"] as String),
                ),
                const SizedBox(height: 8),
                Text(mentor["name"] as String, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xFF6B66FF),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "My Courses"),
        BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: "Inbox"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String subscribers;
  final String instructor;
  final String category;

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.subscribers,
    required this.instructor,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(" $rating", style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.person, color: Colors.grey, size: 16),
                        Text(" $subscribers", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=10')),
                        const SizedBox(width: 8),
                        Text(instructor, style: const TextStyle(fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}