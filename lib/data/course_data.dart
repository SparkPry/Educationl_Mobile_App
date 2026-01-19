import '../models/course_model.dart';

final List<Course> courseData = [
  Course(
    id: '1',
    slug: 'dart-flutter',
    title: 'Dart & Flutter',
    category: 'Programming',
    description: 'A complete guide to the Flutter SDK & Flutter Framework for building native iOS and Android apps. This course is fully updated for 2024.',
    duration: '2 hours',
    rating: 4.5,
    image: 'assets/images/FlutterCourseImage.jpg',
    overview: Overview(
      about: [
        'Learn the fundamentals of Dart programming.',
        'Build beautiful and responsive user interfaces with Flutter.',
        'Understand state management in Flutter.',
      ],
      learn: [
        'How to build native mobile apps for both iOS and Android.',
        'How to use Flutter widgets to create stunning UIs.',
        'How to manage state in your Flutter applications.',
      ],
      requirements: [
        'A computer with an internet connection.',
        'Basic programming knowledge is helpful but not required.',
      ],
      forWho: [
        'Beginners who want to learn mobile app development.',
        'Experienced developers who want to learn a new framework.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to Dart',
        lessons: [
          Lesson(
            id: '1',
            slug: 'dart-basics',
            title: 'Dart Basics',
            content: 'Learn the basics of the Dart programming language.',
          ),
          Lesson(
            id: '2',
            slug: 'dart-functions',
            title: 'Dart Functions',
            content: 'Learn about functions in Dart.',
          ),
        ],
      ),
      CurriculumSection(
        section: '2',
        title: 'Introduction to Flutter',
        lessons: [
          Lesson(
            id: '3',
            slug: 'flutter-widgets',
            title: 'Flutter Widgets',
            content: 'Learn about the different types of widgets in Flutter.',
          ),
          Lesson(
            id: '4',
            slug: 'flutter-layouts',
            title: 'Flutter Layouts',
            content: 'Learn how to build layouts in Flutter.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'John Doe',
      title: 'Mobile Developer',
      avatar: 'assets/images/mentor1.jpg',
      bio: 'John Doe is a mobile developer with over 10 years of experience.',
    ),
    reviews: Reviews(
      total: 1234,
      average: 4.5,
    ),
  ),
  Course(
    id: '2',
    slug: 'python-data-science',
    title: 'Python for Data Science',
    category: 'Data Science',
    description: 'Learn Python for data science and machine learning. This course covers everything you need to know to get started in the field of data science.',
    duration: '3 hours',
    rating: 4.8,
    image: 'assets/images/DataScientCourseImage.jpg',
    overview: Overview(
      about: [
        'Learn the fundamentals of Python programming for data science.',
        'Understand how to use popular data science libraries like NumPy, Pandas, and Matplotlib.',
        'Learn the basics of machine learning.',
      ],
      learn: [
        'How to use Python for data analysis and visualization.',
        'How to build machine learning models with scikit-learn.',
        'How to apply your data science skills to real-world problems.',
      ],
      requirements: [
        'A computer with an internet connection.',
        'Basic programming knowledge is helpful but not required.',
      ],
      forWho: [
        'Beginners who want to learn data science.',
        'Experienced developers who want to transition into data science.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to Python',
        lessons: [
          Lesson(
            id: '5',
            slug: 'python-basics',
            title: 'Python Basics',
            content: 'Learn the basics of the Python programming language.',
          ),
          Lesson(
            id: '6',
            slug: 'python-data-structures',
            title: 'Python Data Structures',
            content: 'Learn about the different data structures in Python.',
          ),
        ],
      ),
      CurriculumSection(
        section: '2',
        title: 'Data Science Libraries',
        lessons: [
          Lesson(
            id: '7',
            slug: 'numpy',
            title: 'NumPy',
            content: 'Learn how to use the NumPy library for numerical computing.',
          ),
          Lesson(
            id: '8',
            slug: 'pandas',
            title: 'Pandas',
            content: 'Learn how to use the Pandas library for data manipulation and analysis.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Jane Smith',
      title: 'Data Scientist',
      avatar: 'assets/images/mentor2.jpg',
      bio: 'Jane Smith is a data scientist with over 5 years of experience.',
    ),
    reviews: Reviews(
      total: 5678,
      average: 4.8,
    ),
  ),
];
