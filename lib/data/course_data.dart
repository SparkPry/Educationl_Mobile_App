import '../models/course_model.dart';

final List<Course> courseData = [
  Course(
    id: '1',
    slug: 'dart-flutter',
    title: 'Dart & Flutter',
    category: 'Programming',
    description:
        'A complete guide to the Flutter SDK & Flutter Framework for building native iOS and Android apps. This course is fully updated for 2024.',
    duration: '2 hours',
    rating: 4.5,
    image: 'assets/images/Flutter.png',
    price: 12.00,
    level: 'beginner',
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
      avatar: 'assets/images/John Doe.jpg',
      bio: 'John Doe is a mobile developer with over 10 years of experience.',
    ),
    reviews: Reviews(total: 1234, average: 4.5),
    progress: 0.6,
  ),
  Course(
    id: '2',
    slug: 'python-data-science',
    title: 'Python for Data Science',
    category: 'Data Science',
    description:
        'Learn Python for data science and machine learning. This course covers everything you need to know to get started in the field of data science.',
    duration: '3 hours',
    rating: 4.8,
    image: 'assets/images/DataScientCourseImage.jpg',
    price: 12.00,
    level: 'beginner',
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
            content:
                'Learn how to use the NumPy library for numerical computing.',
          ),
          Lesson(
            id: '8',
            slug: 'pandas',
            title: 'Pandas',
            content:
                'Learn how to use the Pandas library for data manipulation and analysis.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Alice',
      title: 'Data Scientist',
      avatar: 'assets/images/Alice.jpg',
      bio: 'Jane Smith is a data scientist with over 5 years of experience.',
    ),
    reviews: Reviews(total: 5678, average: 4.8),
    progress: null,
  ),
  Course(
    id: '3',
    slug: 'ui-ux-design',
    title: 'UI/UX Design',
    category: 'Design',
    description:
        'Learn the fundamentals of UI/UX design. This course covers everything you need to know to get started in the field of design.',
    duration: '4 hours',
    rating: 4.9,
    image: 'assets/images/UI UX.png',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: [
        'Learn the fundamentals of UI/UX design.',
        'Understand how to create user-centered designs.',
        'Learn the basics of design thinking.',
      ],
      learn: [
        'How to create wireframes, mockups, and prototypes.',
        'How to use popular design tools like Figma and Sketch.',
        'How to apply your design skills to real-world problems.',
      ],
      requirements: [
        'A computer with an internet connection.',
        'No prior design experience is required.',
      ],
      forWho: [
        'Beginners who want to learn UI/UX design.',
        'Experienced designers who want to improve their skills.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to Design',
        lessons: [
          Lesson(
            id: '9',
            slug: 'design-basics',
            title: 'Design Basics',
            content: 'Learn the basics of design theory.',
          ),
          Lesson(
            id: '10',
            slug: 'design-principles',
            title: 'Design Principles',
            content: 'Learn about the principles of design.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Bob',
      title: 'UI/UX Designer',
      avatar: 'assets/images/Bob.jpg',
      bio: 'Peter Jones is a UI/UX designer with over 7 years of experience.',
    ),
    reviews: Reviews(total: 9101, average: 4.9),
    progress: 0.0,
  ),
  Course(
    id: '4',
    slug: 'digital-marketing',
    title: 'Digital Marketing',
    category: 'Marketing',
    description:
        'Learn the fundamentals of digital marketing. This course covers everything you need to know to get started in the field of marketing.',
    duration: '2.5 hours',
    rating: 4.7,
    image: 'assets/images/Digital marketing.jpg',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: [
        'Learn the fundamentals of digital marketing.',
        'Understand how to create and implement marketing campaigns.',
        'Learn the basics of SEO, SEM, and social media marketing.',
      ],
      learn: [
        'How to create a digital marketing strategy.',
        'How to use popular marketing tools like Google Analytics and Google Ads.',
        'How to apply your marketing skills to real-world problems.',
      ],
      requirements: [
        'A computer with an internet connection.',
        'No prior marketing experience is required.',
      ],
      forWho: [
        'Beginners who want to learn digital marketing.',
        'Experienced marketers who want to improve their skills.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to Marketing',
        lessons: [
          Lesson(
            id: '11',
            slug: 'marketing-basics',
            title: 'Marketing Basics',
            content: 'Learn the basics of marketing theory.',
          ),
          Lesson(
            id: '12',
            slug: 'marketing-principles',
            title: 'Marketing Principles',
            content: 'Learn about the principles of marketing.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Charlie',
      title: 'Digital Marketer',
      avatar: 'assets/images/Charlie.jpg',
      bio:
          'Mary Johnson is a digital marketer with over 3 years of experience.',
    ),
    reviews: Reviews(total: 1121, average: 4.7),
    progress: 1.0,
  ),
  Course(
    id: '5',
    slug: 'web-development-basics',
    title: 'Web Development Basics',
    category: 'Programming',
    description:
        'A comprehensive introduction to web development, covering HTML, CSS, and JavaScript.',
    duration: '3.5 hours',
    rating: 4.6,
    price: 12,
    level: 'beginner',
    image: 'assets/images/Web development.png',
    overview: Overview(
      about: [
        'Learn the core technologies of the web: HTML, CSS, and JavaScript.',
        'Build responsive and interactive websites from scratch.',
        'Understand how web pages are structured and styled.',
      ],
      learn: [
        'How to write semantic HTML.',
        'How to style web pages with CSS.',
        'How to add interactivity with JavaScript.',
      ],
      requirements: [
        'A computer with an internet connection.',
        'No prior programming or web development experience is required.',
      ],
      forWho: [
        'Beginners who want to learn web development.',
        'Anyone interested in how websites are built.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to HTML',
        lessons: [
          Lesson(
            id: '13',
            slug: 'html-structure',
            title: 'HTML Document Structure',
            content: 'Understand the basic structure of an HTML document.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Diana',
      title: 'Web Developer',
      avatar: 'assets/images/Diana.jpg',
      bio:
          'Michael Green is a seasoned web developer with a passion for teaching.',
    ),
    reviews: Reviews(total: 890, average: 4.6),
    progress: 0.25,
  ),
  Course(
    id: '6',
    slug: 'advanced-flutter-concepts',
    title: 'Advanced Flutter Concepts',
    category: 'Programming',
    description:
        'Deep dive into advanced topics in Flutter, including custom widgets, animations, and more complex state management.',
    duration: '5 hours',
    rating: 4.9,
    price: 12.00,
    level: 'beginner',
    image: 'assets/images/Flutter.png',
    overview: Overview(
      about: [
        'Explore advanced Flutter features and patterns.',
        'Learn to build highly performant and complex UIs.',
        'Master various state management solutions beyond the basics.',
      ],
      learn: [
        'How to create implicit and explicit animations.',
        'Techniques for building custom widgets and render objects.',
        'Integrating with platform-specific code.',
      ],
      requirements: [
        'Familiarity with Flutter basics and Dart programming.',
        'A computer with an internet connection.',
      ],
      forWho: [
        'Flutter developers looking to deepen their knowledge.',
        'Anyone building complex Flutter applications.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Custom Widgets',
        lessons: [
          Lesson(
            id: '14',
            slug: 'custom-painters',
            title: 'Custom Painters and Render Objects',
            content: 'Learn to draw custom graphics and control layout.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'John Doe',
      title: 'Senior Mobile Developer',
      avatar: 'assets/images/John Doe.jpg',
      bio:
          'John Doe is a mobile developer with over 10 years of experience, specializing in Flutter.',
    ),
    reviews: Reviews(total: 2100, average: 4.9),
    progress: 1.0,
  ),
  Course(
    id: '7',
    slug: 'machine-learning-with-python',
    title: 'Machine Learning with Python',
    category: 'Data Science',
    description:
        'An in-depth course on machine learning algorithms and their implementation using Python and popular libraries.',
    duration: '6 hours',
    rating: 4.8,
    image: 'assets/images/Machine learning with python.jpg',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: [
        'Gain a solid understanding of machine learning principles.',
        'Implement various ML algorithms from scratch and using libraries.',
        'Learn to preprocess data and evaluate model performance.',
      ],
      learn: [
        'Supervised and unsupervised learning techniques.',
        'Regression, classification, and clustering algorithms.',
        'Using scikit-learn, TensorFlow, and Keras.',
      ],
      requirements: [
        'Intermediate Python programming skills.',
        'Basic understanding of linear algebra and calculus.',
        'A computer with an internet connection and Python installed.',
      ],
      forWho: [
        'Data scientistrs and analysts looking to expand ML knowledge.',
        'Developers interested in building intelligent applications.',
      ],
    ),
    curriculum: [
      CurriculumSection(
        section: '1',
        title: 'Introduction to Machine Learning',
        lessons: [
          Lesson(
            id: '15',
            slug: 'ml-fundamentals',
            title: 'Fundamentals of ML',
            content: 'Understanding the basics of machine learning.',
          ),
        ],
      ),
    ],
    instructor: Instructor(
      name: 'Eve',
      title: 'Lead Data Scientist',
      avatar: 'assets/images/Eve.jpg',
      bio:
          'Jane Smith is a lead data scientist with extensive experience in machine learning.',
    ),
    reviews: Reviews(total: 3500, average: 4.8),
    progress: 0.8,
  ),
  Course(
    id: '8',
    slug: 'advanced-python',
    title: 'Advanced Python',
    category: 'Programming',
    description:
        'Take your Python skills to the next level with this advanced course.',
    duration: '4 hours',
    rating: 4.8,
    image: 'assets/images/advance python.jpg',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: ['Advanced Python concepts'],
      learn: ['Advanced Python'],
      requirements: ['Intermediate Python'],
      forWho: ['Python developers'],
    ),
    curriculum: [],
    instructor: Instructor(
      name: 'Alice',
      title: 'Python Developer',
      avatar: 'assets/images/Alice.jpg',
      bio: '',
    ),
    reviews: Reviews(total: 4200, average: 4.8),
    progress: null,
  ),
  Course(
    id: '9',
    slug: 'flutter-testing',
    title: 'Flutter Testing',
    category: 'Programming',
    description: 'Learn how to write tests for your Flutter applications.',
    duration: '3 hours',
    rating: 4.9,
    image: 'assets/images/Flutter.png',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: ['Flutter testing concepts'],
      learn: ['Unit, widget, and integration testing'],
      requirements: ['Intermediate Flutter'],
      forWho: ['Flutter developers'],
    ),
    curriculum: [],
    instructor: Instructor(
      name: 'John Doe',
      title: 'Flutter Developer',
      avatar: 'assets/images/John Doe.jpg',
      bio: '',
    ),
    reviews: Reviews(total: 3100, average: 4.9),
    progress: 0.0,
  ),
  Course(
    id: '10',
    slug: 'data-visualization',
    title: 'Data Visualization',
    category: 'Data Science',
    description:
        'Learn how to create beautiful data visualizations with Python.',
    duration: '2 hours',
    rating: 4.8,
    image: 'assets/images/DataScientCourseImage.jpg',
    price: 12.00,
    level: 'beginner',
    overview: Overview(
      about: ['Data visualization concepts'],
      learn: ['Matplotlib and Seaborn'],
      requirements: ['Intermediate Python'],
      forWho: ['Data scientists'],
    ),
    curriculum: [],
    instructor: Instructor(
      name: 'Bob',
      title: 'Data Scientist',
      avatar: 'assets/images/Bob.jpg',
      bio: '',
    ),
    reviews: Reviews(total: 2500, average: 4.8),
    progress: 1.0,
  ),
];
