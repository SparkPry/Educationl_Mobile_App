class Mentor {
  final String name;
  final String profileImage;
  final String title;
  final String about;
  final List<String> courses;
  final String students;
  final String rating;
  final String reviewsCount;
  final List<MentorReview> reviews;

  Mentor({
    required this.name,
    required this.profileImage,
    required this.title,
    required this.about,
    required this.courses,
    required this.students,
    required this.rating,
    required this.reviewsCount,
    required this.reviews,
  });
}

class MentorReview {
  final String userName;
  final String? userImage;
  final String comment;
  final double rating;
  final String date;

  MentorReview({
    required this.userName,
    this.userImage,
    required this.comment,
    required this.rating,
    required this.date,
  });
}
