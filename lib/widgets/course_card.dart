import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../widgets/course_image.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: course.image.startsWith('http')
                  ? Image.network(
                      course.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      headers: const {'User-Agent': 'Mozilla/5.0'},
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    )
                  : Image.asset(
                      course.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.category,
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          " ${course.rating}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.person, color: Colors.grey, size: 16),
                        Text(
                          " ${course.reviews.total}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          child: ClipOval(
                            child: Image.network(
                              course.instructor.avatar,
                              fit: BoxFit.cover,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 12);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          course.instructor.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
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
