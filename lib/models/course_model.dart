class Course {
  final String id;
  final String slug;
  final String title;
  final String category;
  final String description;
  final String duration;
  final double rating;
  final String image;
  final Overview overview;
  final List<CurriculumSection> curriculum;
  final Instructor instructor;
  final Reviews reviews;
  final double? progress; // Added for progress tracking
  final double price;
  final String level;
  final double? discountPrice;

  Course({
    required this.id,
    required this.slug,
    required this.title,
    required this.category,
    required this.description,
    required this.duration,
    required this.rating,
    required this.image,
    this.discountPrice,
    required this.overview,
    required this.curriculum,
    required this.instructor,
    required this.reviews,
    required this.price,
    required this.level,
    this.progress, // Added to constructor
  });

  Course copyWith({
    String? id,
    String? slug,
    String? title,
    String? category,
    String? description,
    String? duration,
    double? rating,
    String? image,
    double? price,
    String? level,
    double? discountPrice,
    Overview? overview,
    List<CurriculumSection>? curriculum,
    Instructor? instructor,
    Reviews? reviews,
    double? progress,
  }) {
    return Course(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      image: image ?? this.image,
      price: price ?? this.price,
      level: level ?? this.level,
      discountPrice: discountPrice ?? this.discountPrice,
      overview: overview ?? this.overview,
      curriculum: curriculum ?? this.curriculum,
      instructor: instructor ?? this.instructor,
      reviews: reviews ?? this.reviews,
      progress: progress ?? this.progress,
    );
  }
}

/* ---------------- OVERVIEW ---------------- */

class Overview {
  final List<String> about;
  final List<String> learn;
  final List<String> requirements;
  final List<String> forWho;

  Overview({
    required this.about,
    required this.learn,
    required this.requirements,
    required this.forWho,
  });
}

/* ---------------- CURRICULUM ---------------- */

class CurriculumSection {
  final String section;
  final String title;
  final List<Lesson> lessons;

  CurriculumSection({
    required this.section,
    required this.title,
    required this.lessons,
  });
}

/* ---------------- LESSON ---------------- */

class Lesson {
  final String id;
  final String slug;
  final String title;
  final String content;

  // Video support
  final String? videoUrl;
  final int? videoDuration; // seconds
  final bool isFreePreview;

  Lesson({
    required this.id,
    required this.slug,
    required this.title,
    required this.content,
    this.videoUrl,
    this.videoDuration,
    this.isFreePreview = false,
  });
}

/* ---------------- INSTRUCTOR ---------------- */

class Instructor {
  final String name;
  final String title;
  final String avatar;
  final String bio;

  Instructor({
    required this.name,
    required this.title,
    required this.avatar,
    required this.bio,
  });
}

/* ---------------- REVIEWS ---------------- */

class Reviews {
  final int total;
  final double average;

  Reviews({required this.total, required this.average});
}
