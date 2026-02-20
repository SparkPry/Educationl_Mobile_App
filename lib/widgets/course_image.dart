import 'package:flutter/material.dart';

class CourseImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CourseImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    // Check if image is network or local
    final bool isNetwork = image.startsWith('http');

    return isNetwork
        ? Image.network(
            image,
            width: width,
            height: height,
            fit: fit,
            headers: const {'User-Agent': 'Mozilla/5.0'},
            errorBuilder: (_, _, _) =>
                const Icon(Icons.image_not_supported),
          )
        : Image.asset(
            image,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.image_not_supported),
          );
  }
}
