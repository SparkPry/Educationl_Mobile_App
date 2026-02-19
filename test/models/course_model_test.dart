import 'package:education_app/models/course_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Course Model Tests', () {
    late Overview testOverview;
    late Instructor testInstructor;
    late Reviews testReviews;

    setUp(() {
      testOverview = Overview(
        about: ['Learn Flutter basics', 'Build mobile apps'],
        learn: ['Widgets', 'State management', 'Navigation'],
        requirements: ['Basic programming knowledge'],
        forWho: ['Beginners', 'Mobile developers'],
      );

      testInstructor = Instructor(
        name: 'John Smith',
        title: 'Senior Flutter Developer',
        avatar: 'https://example.com/instructor.jpg',
        bio: 'Experienced Flutter developer with 10+ years',
      );

      testReviews = Reviews(
        total: 150,
        average: 4.5,
      );
    });

    test('Course should be created with correct properties', () {
      // Arrange
      const courseId = 'course-001';
      const title = 'Flutter Basics';
      const category = 'Mobile Development';
      const duration = '8 weeks';
      const rating = 4.5;
      const image = 'https://example.com/course.jpg';
      const price = 49.99;
      const level = 'Beginner';

      // Act
      final course = Course(
        id: courseId,
        slug: 'flutter-basics',
        title: title,
        category: category,
        description: 'Learn Flutter from scratch',
        duration: duration,
        rating: rating,
        image: image,
        overview: testOverview,
        curriculum: [],
        instructor: testInstructor,
        reviews: testReviews,
        price: price,
        level: level,
      );

      // Assert
      expect(course.id, equals(courseId));
      expect(course.title, equals(title));
      expect(course.category, equals(category));
      expect(course.duration, equals(duration));
      expect(course.rating, equals(rating));
      expect(course.price, equals(price));
      expect(course.level, equals(level));
    });

    test('Course should support optional progress tracking', () {
      // Arrange
      const progress = 45.5;

      // Act
      final course = Course(
        id: 'course-001',
        slug: 'flutter-basics',
        title: 'Flutter Course',
        category: 'Mobile',
        description: 'Description',
        duration: '8 weeks',
        rating: 4.5,
        image: 'image.jpg',
        overview: testOverview,
        curriculum: [],
        instructor: testInstructor,
        reviews: testReviews,
        price: 49.99,
        level: 'Beginner',
        progress: progress,
      );

      // Assert
      expect(course.progress, equals(progress));
    });

    test('Course should support discount price', () {
      // Arrange
      const originalPrice = 99.99;
      const discountPrice = 49.99;

      // Act
      final course = Course(
        id: 'course-001',
        slug: 'flutter-basics',
        title: 'Flutter Course',
        category: 'Mobile',
        description: 'Description',
        duration: '8 weeks',
        rating: 4.5,
        image: 'image.jpg',
        overview: testOverview,
        curriculum: [],
        instructor: testInstructor,
        reviews: testReviews,
        price: originalPrice,
        level: 'Beginner',
        discountPrice: discountPrice,
      );

      // Assert
      expect(course.discountPrice, equals(discountPrice));
      expect(course.discountPrice, lessThan(course.price));
    });
  });

  group('Lesson Model Tests', () {
    test('Lesson should be created with required properties', () {
      // Arrange
      const lessonId = 'lesson-001';
      const title = 'Introduction to Flutter';
      const content = 'Lesson content here';

      // Act
      final lesson = Lesson(
        id: lessonId,
        slug: 'intro-flutter',
        title: title,
        content: content,
      );

      // Assert
      expect(lesson.id, equals(lessonId));
      expect(lesson.title, equals(title));
      expect(lesson.content, equals(content));
      expect(lesson.isFreePreview, isFalse);
    });

    test('Lesson should support video content', () {
      // Arrange
      const videoUrl = 'https://example.com/video.mp4';
      const duration = 3600; // 1 hour in seconds

      // Act
      final lesson = Lesson(
        id: 'lesson-001',
        slug: 'lesson-slug',
        title: 'Video Lesson',
        content: 'Content',
        videoUrl: videoUrl,
        videoDuration: duration,
        isFreePreview: true,
      );

      // Assert
      expect(lesson.videoUrl, equals(videoUrl));
      expect(lesson.videoDuration, equals(duration));
      expect(lesson.isFreePreview, isTrue);
    });
  });

  group('Instructor Model Tests', () {
    test('Instructor should be created with correct properties', () {
      // Arrange
      const name = 'Jane Doe';
      const title = 'Flutter Expert';
      const avatar = 'https://example.com/instructor.jpg';
      const bio = 'Expert Flutter developer';

      // Act
      final instructor = Instructor(
        name: name,
        title: title,
        avatar: avatar,
        bio: bio,
      );

      // Assert
      expect(instructor.name, equals(name));
      expect(instructor.title, equals(title));
      expect(instructor.avatar, equals(avatar));
      expect(instructor.bio, equals(bio));
    });
  });

  group('Overview Model Tests', () {
    test('Overview should contain all required information', () {
      // Arrange
      final about = ['About point 1', 'About point 2'];
      final learn = ['Learn point 1', 'Learn point 2'];
      final requirements = ['Requirement 1'];
      final forWho = ['Beginners', 'Professionals'];

      // Act
      final overview = Overview(
        about: about,
        learn: learn,
        requirements: requirements,
        forWho: forWho,
      );

      // Assert
      expect(overview.about, equals(about));
      expect(overview.learn, equals(learn));
      expect(overview.requirements, equals(requirements));
      expect(overview.forWho, equals(forWho));
    });
  });
}
