import 'package:flutter/material.dart';
import '../services/course_api_service.dart';
import '../models/api_course.dart';
import '../models/course_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  static const String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjAsInJvbGUiOiJzdHVkZW50IiwiaWF0IjoxNzY5Njc2MTg4LCJleHAiOjE3Njk3NjI1ODh9.k-wd4sHo-ZXIC02mPFl5lUhSF-dtpYoF9tHeC92iyWs';

  List<ApiCourse> _apiCourses = [];
  List<ApiCourse> _filteredCourses = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final courses = await CourseApiService.fetchCourses(token);
      setState(() {
        _apiCourses = courses;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading courses: $e');
      setState(() => _loading = false);
    }
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _filteredCourses = []);
      return;
    }

    final lower = query.toLowerCase();
    setState(() {
      _filteredCourses = _apiCourses.where((c) {
        return c.title.toLowerCase().contains(lower) ||
            c.category.toLowerCase().contains(lower);
      }).toList();
    });
  }

  /// 🔑 Convert ApiCourse → Course (UI MODEL)
  Course _toCourse(ApiCourse api) {
    return Course(
      id: api.id.toString(),
      slug: api.title.toLowerCase().replaceAll(' ', '-'),
      title: api.title,
      category: api.category,
      description: api.longDescription,
      duration: api.duration,
      rating: 4.5,
      image: api.thumbnail,

      overview: Overview(about: [], learn: [], requirements: [], forWho: []),

      curriculum: [],

      instructor: Instructor(
        name: 'Instructor',
        title: 'Teacher',
        avatar: 'assets/images/mentor1.jpg',
        bio: '',
      ),

      reviews: Reviews(total: 0, average: 4.5),

      price: api.discountPrice ?? api.price,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _searchBar(),
              const Divider(height: 1),
              Expanded(child: _results()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search courses...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() => _filteredCourses = []);
            },
          ),
        ],
      ),
    );
  }

  Widget _results() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Start typing to search'));
    }

    if (_filteredCourses.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: _filteredCourses.length,
      itemBuilder: (context, index) {
        final apiCourse = _filteredCourses[index];

        return ListTile(
          leading: const Icon(Icons.search, color: Color(0xFF6B66FF)),
          title: Text(apiCourse.title),
          subtitle: Text(apiCourse.category),
          onTap: () {
            final course = _toCourse(apiCourse);

            Navigator.pushNamed(
              context,
              '/course',
              arguments: course, // ✅ ALWAYS Course
            );
          },
        );
      },
    );
  }
}
