class Certificate {
  final String title;
  final String organization;
  final String date;
  final String imageUrl;

  Certificate({
    required this.title,
    required this.organization,
    required this.date,
    required this.imageUrl,
  });
}

class UserModel {
  final String name;
  final String email;
  final String avatar;
  final String? bio;
  final String? phoneNumber;
  final String? joinDate;
  final int? coursesCompleted;
  final int? learningHours;
  final List<Certificate>? certificates;
  final List<String>? enrolledCourseNames;
  final Set<String> ongoingCourseIds;
  final Set<String> completedCourseIds;
  final Set<String> favoriteCourseIds;

  UserModel({
    required this.name,
    required this.email,
    required this.avatar,
    this.bio,
    this.phoneNumber,
    this.joinDate,
    this.coursesCompleted,
    this.learningHours,
    this.certificates,
    this.enrolledCourseNames,
    this.ongoingCourseIds = const {},
    this.completedCourseIds = const {},
    this.favoriteCourseIds = const {},
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? avatar,
    String? bio,
    String? phoneNumber,
    String? joinDate,
    int? coursesCompleted,
    int? learningHours,
    List<Certificate>? certificates,
    List<String>? enrolledCourseNames,
    Set<String>? ongoingCourseIds,
    Set<String>? completedCourseIds,
    Set<String>? favoriteCourseIds,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      joinDate: joinDate ?? this.joinDate,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      learningHours: learningHours ?? this.learningHours,
      certificates: certificates ?? this.certificates,
      enrolledCourseNames: enrolledCourseNames ?? this.enrolledCourseNames,
      ongoingCourseIds: ongoingCourseIds ?? this.ongoingCourseIds,
      completedCourseIds: completedCourseIds ?? this.completedCourseIds,
      favoriteCourseIds: favoriteCourseIds ?? this.favoriteCourseIds,
    );
  }
}
