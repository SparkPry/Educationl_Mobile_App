import 'package:education_app/models/badge_model.dart';

final List<Badge> allBadges = [
  Badge(
    name: "First Step",
    description: "Complete your first lesson.",
    iconUrl: "assets/images/badge_first_step.png", // Assuming you'll have these assets
    isEarned: true,
  ),
  Badge(
    name: "Course Conqueror",
    description: "Complete an entire course.",
    iconUrl: "assets/images/badge_course_conqueror.png",
    isEarned: true,
  ),
  Badge(
    name: "Weekend Warrior",
    description: "Study on a Saturday or Sunday.",
    iconUrl: "assets/images/badge_weekend_warrior.png",
    isEarned: true,
  ),
  Badge(
    name: "Night Owl",
    description: "Complete a lesson after 10 PM.",
    iconUrl: "assets/images/badge_night_owl.png",
    isEarned: false,
  ),
  Badge(
    name: "Perfect Week",
    description: "Study every day for 7 days straight.",
    iconUrl: "assets/images/badge_perfect_week.png",
    isEarned: false,
  ),
  Badge(
    name: "Specialist",
    description: "Complete 3 courses in the same category.",
    iconUrl: "assets/images/badge_specialist.png",
    isEarned: false,
  ),
];

// Dummy data for the learning streak calendar
// Using a Set for efficient 'contains' check
final learningStreakDays = {1, 2, 3, 5, 6, 9, 10, 11, 12, 14};
