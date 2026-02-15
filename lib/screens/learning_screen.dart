import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:education_app/screens/quiz_screen.dart';
import 'package:education_app/models/course_model.dart';
import 'package:education_app/services/course_api_service.dart';

class LearningScreen extends StatefulWidget {
  final Course course;
  const LearningScreen({super.key, required this.course});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  Future<void> _launchYouTubeVideo() async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=h9C6JfkSLE4');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  List<Map<String, dynamic>> _lessons = [];
  bool _isLoading = true;

  final String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjYsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzcwODY4NjA5LCJleHAiOjE3NzE0NzM0MDl9.gsjcqfFB7hVIrVu4uD9cicyrBpAIKrjfvGIgADP0VH0';
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      final lessons = await CourseApiService.fetchLessons(
        token: _token,
        courseId: widget.course.id,
      );

      if (!mounted) return;

      setState(() {
        _lessons = lessons;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    final String summary = course.overview.about.isNotEmpty
        ? course.overview.about.first
        : course.description;

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
                  title: const Text(
                    "Learning Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: true,
                ),

                // ---------- HEADER ----------
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // THUMBNAIL (STATIC FOR NOW)
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

                        // ✅ TITLE (DYNAMIC)
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ✅ LEVEL + DURATION + CATEGORY
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ⭐ LEVEL
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                course.level,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // ⏱ DURATION (CENTER)
                            Row(
                              children: [
                                const Icon(
                                  Icons.timer_outlined,
                                  size: 18,
                                  color: const Color(0xFF6B66FF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  course.duration,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 12, 11, 11),
                                  ),
                                ),
                              ],
                            ),

                            // 📚 CATEGORY
                            Row(
                              children: [
                                const Icon(
                                  Icons.category_outlined,
                                  size: 18,
                                  color: const Color(0xFF6B66FF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  course.category,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
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
                _buildSummaryTab(summary),
                _buildLessonsTab(), // ✅ dynamic API lessons
                const QuizScreen(), // keep static for now
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab(String summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this course',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_lessons.isEmpty) {
      return const Center(
        child: Text(
          'No lessons available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        final lesson = _lessons[index];

        final bool isCompleted = lesson['completed'] == 1;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            child: const Icon(Icons.play_arrow, color: Colors.white),
          ),
          title: Text(
            lesson['title'],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Lesson ${index + 1}'),
          trailing: isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,

          onTap: () async {
            final url = lesson['video_url'];

            if (url == null || url.toString().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Video not available")),
              );
              return;
            }

            final Uri videoUri = Uri.parse(url);

            if (await canLaunchUrl(videoUri)) {
              await launchUrl(videoUri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Could not open video")),
              );
            }
          },
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
