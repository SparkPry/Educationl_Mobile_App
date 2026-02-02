import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_app/screens/lesson_list_screen.dart';
import 'package:education_app/screens/quiz_screen.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  // Function to launch the YouTube URL
  Future<void> _launchYouTubeVideo() async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=h9C6JfkSLE4');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: true,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://img.youtube.com/vi/h9C6JfkSLE4/hqdefault.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: AppColors.primaryColor,
                                  size: 40,
                                ),
                                onPressed: _launchYouTubeVideo,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'UX/UI Essentials',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '4.7',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '(4,579 reviews)',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Design',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      tabs: [
                        Tab(text: 'Summary'),
                        Tab(text: 'Lessons'),
                        Tab(text: 'Quizzes'),
                      ],
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryColor,
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildSummaryTab(),
                const LessonListScreen(),
                const QuizScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this course',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
