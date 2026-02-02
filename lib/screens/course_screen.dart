import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../data/review_data.dart';
import '../models/review.dart';
import '../payment_screen.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context)!.settings.arguments as Course;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Stack(
                        children: [
                          Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              image: DecorationImage(
                                image: course.image.startsWith('http')
                                    ? NetworkImage(course.image)
                                    : AssetImage(course.image) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: CircleAvatar(
                              backgroundColor: Colors.black45,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// RATING + CATEGORY
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${course.rating} (${course.reviews.total} reviews)',
                            ),
                            const SizedBox(width: 12),
                            Text(
                              course.category,
                              style: const TextStyle(
                                color: Color(0xFF6B66FF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// STATS
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statCard(
                              '${course.reviews.total}',
                              'members',
                              Icons.people_outline,
                            ),
                            _statCard(
                              course.duration,
                              '',
                              Icons.timer_outlined,
                            ),
                            _statCard(
                              'Certificate',
                              '',
                              Icons.card_membership_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// TABS
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF6B66FF),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF6B66FF),
                        tabs: const [
                          Tab(text: 'About'),
                          Tab(text: 'Lessons'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                    ],
                  ),
                ),

                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _about(course),
                        _lessons(course),
                        _reviews(course),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// ENROLL BUTTON
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 60,
                    decoration: BoxDecoration(
                      color: _hexToColor('6B66FF').withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaymentScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Enroll Course \$${course.price}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- HELPERS ----------

  Widget _statCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B66FF)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _about(Course course) {
    final String longDescription = course.overview.about.isNotEmpty
        ? course.overview.about.first
        : course.description;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// INSTRUCTOR
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: course.instructor.avatar.startsWith('http')
                    ? NetworkImage(course.instructor.avatar)
                    : AssetImage(course.instructor.avatar) as ImageProvider,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.instructor.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    course.instructor.title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'About Course',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            longDescription,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lessons(Course course) {
    return const Center(
      child: Text(
        'Lessons will be available soon',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _reviews(Course course) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: dummyReviews.length,
      itemBuilder: (_, i) => _reviewCard(dummyReviews[i]),
    );
  }

  Widget _reviewCard(Review review) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(review.avatar)),
      title: Text(review.name),
      subtitle: Text(review.comment),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 16),
          Text(review.rating.toString()),
        ],
      ),
    );
  }
}
