import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with WidgetsBindingObserver {
  static const String _baseUrl =
      'https://e-learning-api-production-a6d4.up.railway.app';

  bool _isLoading = true;
  bool _needsRefresh = false;

  // category -> thumbnail
  Map<String, String> _categories = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchCategories();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _needsRefresh) {
      // Reload categories only if something changed
      _fetchCategories();
      _needsRefresh = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/courses'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        final Map<String, String> uniqueCategories = {};

        for (var course in data) {
          final category = course['category'];
          final thumbnail = course['thumbnail'];

          // only add first occurrence
          if (!uniqueCategories.containsKey(category)) {
            uniqueCategories[category] = thumbnail;
          }
        }

        if (!mounted) return;

        setState(() {
          _categories = uniqueCategories;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final categoryName = _categories.keys.elementAt(index);
                final thumbnail = _categories.values.elementAt(index);

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/myCourses', // make sure this route exists
                      arguments: categoryName,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(thumbnail),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
