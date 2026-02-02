import 'package:flutter/material.dart';
import 'package:education_app/utils/app_colors.dart';

class LessonListScreen extends StatelessWidget {
  const LessonListScreen({super.key});

  // Placeholder data for lessons
  final List<Map<String, String>> lessons = const [
    {'title': 'Developing Checker style', 'duration': '18.02 mins'},
    {'title': 'Advanced UI/UX Principles', 'duration': '25.30 mins'},
    {'title': 'User Research Techniques', 'duration': '12.15 mins'},
    {'title': 'Prototyping in Figma', 'duration': '30.00 mins'},
    {'title': 'Design Systems Overview', 'duration': '10.05 mins'},
    {'title': 'Client Communication', 'duration': '15.45 mins'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background white
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemCount: lessons.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey, // Light gray divider
          height: 32, // Space for divider + vertical spacing
          thickness: 0.5,
        ),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return Row(
            children: [
              // Circular play button
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Blue background
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white, // White play icon
                  size: 24,
                ),
              ),
              const SizedBox(width: 16), // Space between icon and text

              // Lesson details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500, // Medium-bold font
                      color: Colors.black87, // Dark gray / black
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson['duration']!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600], // Light gray color
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}