import 'package:flutter/material.dart';
import '../data/course_data.dart';
import '../models/course_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  List<Course> allCourses = []; // for search
  List<Course> filteredCourses = []; // for search

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: '');

    // allCourses = courseData; // original data
    filteredCourses = []; // empty at start
  }

  void _searchCourses(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCourses = [];
      });
      return;
    }

    final searchLower = query.toLowerCase();

    setState(() {
      filteredCourses = allCourses.where((course) {
        return course.title.toLowerCase().contains(searchLower) ||
            course.category.toLowerCase().contains(searchLower);
      }).toList();
    });
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
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            children: [
              _buildSearchBar(),
              const Divider(height: 1, color: Colors.black12),
              Expanded(child: _buildSuggestionList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _searchCourses, // for search
              style: const TextStyle(fontSize: 18.0, color: Colors.black87),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.black38),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.black38),
                  onPressed: () => _searchController.clear(),
                ),
                border: InputBorder.none,
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.black38),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onPressed: () {
              Navigator.pushNamed(context, '/filter');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionList() {
    if (_searchController.text.isEmpty) {
      return const Center(child: Text('Start typing to search'));
    }

    if (filteredCourses.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];

        return ListTile(
          leading: const Icon(Icons.search, color: Color(0xFF6B66FF)),
          title: Text(course.title),
          subtitle: Text(course.category),
          onTap: () {
            Navigator.pushNamed(context, '/course', arguments: course);
          },
        );
      },
    );
  }
}
