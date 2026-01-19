import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/review.dart';
import '../data/review_data.dart';

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
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;

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
                      // Top Section with AppBar and Image
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
                                image: NetworkImage(course.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/home',
                                      (route) => false,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Course Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${course.rating} (${course.reviews.total} reviews)',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  course.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatCard(
                                  '${course.reviews.total}',
                                  'members',
                                  Icons.people_outline,
                                ),
                                _buildStatCard(
                                  course.duration,
                                  '',
                                  Icons.timer_outlined,
                                ),
                                _buildStatCard(
                                  'Certificate',
                                  '',
                                  Icons.card_membership_outlined,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Tabs Section
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAboutTab(course),
                      _buildLessonsTab(course),
                      _buildReviewsTab(course),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Button
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _hexToColor('6B66FF').withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Enroll Course \$75.00',
                        style: TextStyle(
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

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (label.isNotEmpty)
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(Course course) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(course.instructor.avatar),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.instructor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    course.instructor.title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'About Course',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            course.description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsTab(Course course) {
    final List<Lesson> allLessons = course.curriculum
        .expand((section) => section.lessons)
        .toList();

    if (allLessons.isEmpty) {
      return const Center(
        child: Text(
          "No lessons available for this course yet.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: allLessons.length,
      itemBuilder: (context, index) {
        final lesson = allLessons[index];
        return _buildLessonItem(lesson, index);
      },
    );
  }

  Widget _buildLessonItem(Lesson lesson, int index) {
    String lessonNumber = (index + 1).toString().padLeft(2, '0');
    String duration = lesson.videoDuration != null
        ? '${(lesson.videoDuration! / 60).toStringAsFixed(2)} mins'
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                lessonNumber,
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  duration,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(Course course) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: dummyReviews.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildRatingSummary(course);
        }
        final review = dummyReviews[index - 1];
        return _buildReviewCommentCard(review);
      },
    );
  }

  Widget _buildRatingSummary(Course course) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          // Average Rating
          Column(
            children: [
              Text(
                course.reviews.average.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text('out of 5'),
            ],
          ),
          const SizedBox(width: 20),
          // Progress Bars
          Expanded(
            child: Column(
              children: [
                _buildProgressBarRow(5, 0.7),
                _buildProgressBarRow(4, 0.2),
                _buildProgressBarRow(3, 0.05),
                _buildProgressBarRow(2, 0.03),
                _buildProgressBarRow(1, 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarRow(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star'),
          const SizedBox(width: 5),
          const Icon(Icons.star, color: Colors.amber, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _hexToColor('4A89F3'),
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text('${(percentage * 100).toInt()}%'),
        ],
      ),
    );
  }

  Widget _buildReviewCommentCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(review.avatar),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 5),
                        Text(review.rating.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.timestamp,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.comment),
        ],
      ),
    );
  }
}
