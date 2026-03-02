import 'package:flutter/material.dart';
import '../services/course_api_service.dart';
import '../models/api_course.dart';
import '../models/course_model.dart';
import '../utils/app_colors.dart';

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

  Course _toCourse(ApiCourse api) {
    return Course(
      id: api.id.toString(),
      slug: api.title.toLowerCase().replaceAll(' ', '-'),
      title: api.title,
      category: api.category,
      description: api.longDescription,
      duration: api.duration,
      rating: 4.5,
      level: api.level,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: 'Search courses...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            border: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black, size: 20),
              onPressed: () {
                _searchController.clear();
                _search('');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(child: _results()),
        ],
      ),
    );
  }

  Widget _results() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Text(
              'Search for courses or topics',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_filteredCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Text(
              'No results found for "${_searchController.text}"',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _filteredCourses.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final apiCourse = _filteredCourses[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_book,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          title: Text(
            apiCourse.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            apiCourse.category,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
          onTap: () {
            final course = _toCourse(apiCourse);
            Navigator.pushNamed(context, '/course', arguments: course);
          },
        );
      },
    );
  }
}
