# Education App - Feature Documentation

## Overview

AngkorEdu (Education App) is a comprehensive mobile learning platform built with Flutter that connects learners with quality educational content. It provides a complete e-learning experience with course discovery, enrollment, learning progress tracking, and community engagement features.

---

## Core Features

### 1. Authentication System
- **User Registration**: Create new account with email and password
- **User Login**: Secure authentication with token-based session management
- **Password Recovery**: Forgot password and reset functionality via email verification
- **Session Management**: Automatic token storage and management with SharedPreferences
- **Role-Based Access**: Different user roles (student, instructor, admin)

**Key Screens:**
- `LoginScreen`: Sign in/Sign up interface with toggle
- `ForgotPasswordScreen`: Password recovery flow
- `VerificationScreen`: Email/OTP verification
- `NewPasswordScreen`: Password reset interface

---

### 2. Course Discovery & Browsing
- **Course Catalog**: Browse all available courses with detailed information
- **Category Filtering**: Filter courses by category (e.g., Programming, Design, Business)
- **Search Functionality**: Full-text search across course titles and descriptions
- **Advanced Filtering**: Filter by level (Beginner, Intermediate, Advanced), price, rating
- **Course Details**: Comprehensive course information including syllabus, instructor bio, reviews

**Key Screens:**
- `HomeScreen`: Main dashboard with featured courses
- `CategoryScreen`: Browse courses by category
- `CourseScreen`: Detailed course view with curriculum
- `SearchScreen`: Search and discover courses
- `FilterScreen`: Advanced filtering options

---

### 3. Learning Experience
- **Lessons & Content**: Structured curriculum with multiple lessons
- **Video Content**: Video lectures with playback controls
- **Progress Tracking**: Track completion percentage for each course
- **Offline Support**: Prepare for offline content access
- **Quiz System**: Assessment through interactive quizzes

**Key Screens:**
- `LessonListScreen`: View all lessons in a course
- `LearningScreen`: Main learning/video watching interface
- `QuizScreen`: Interactive quiz presentations

---

### 4. Course Management
- **My Courses**: View enrolled courses with progress
- **Course Enrollment**: Purchase and enroll in courses
- **Progress Dashboard**: Visual progress indicators for each course
- **Bookmarks/Favorites**: Save courses for later

**Key Screens:**
- `MyCoursesScreen`: View all enrolled courses

---

### 5. Payment System
- **Multiple Payment Methods**: Support various payment options
- **Secure Transactions**: Integration with payment gateway
- **Invoice Generation**: E-receipts for purchases
- **Payment History**: View transaction history

**Key Screens:**
- `PaymentMethodScreen`: Select payment method
- `AddPaymentScreen`: Add new payment method
- `EReceiptScreen`: View purchase receipts

---

### 6. User Profile & Settings
- **Profile Management**: View and edit user information
- **Avatar/Profile Picture**: Upload and manage user avatar
- **Account Settings**: Update email, phone, preferences
- **Security Settings**: Password management and privacy controls
- **Privacy Policy**: Terms and conditions compliance

**Key Screens:**
- `ProfileScreen`: View user profile
- `EditProfileScreen`: Modify profile information
- `SecurityScreen`: Security settings
- `PrivacyPolicyScreen`: Legal information

---

### 7. Communication & Support
- **Inbox System**: Private messaging between users
- **Notifications**: Real-time notifications for courses and messages
- **Help Center**: FAQ and support resources
- **Invite Friends**: Referral system to invite other learners

**Key Screens:**
- `InboxScreen`: Message list and conversations
- `MessageConversationScreen`: Individual conversation view
- `NotificationScreen`: View all notifications
- `HelpCenterScreen`: Support resources
- `InviteFriendsScreen`: Referral interface

---

### 8. Additional Features
- **Onboarding Flow**: Introduction to app features for new users
- **App Navigation**: Bottom navigation with quick access to main sections
- **Dark/Light Theme**: Customizable app appearance (if implemented)
- **Multi-language Support**: Localization support with intl package

**Key Screens:**
- `OnboardingScreen`: First-time user experience
- `AppShell`: Main navigation container

---

## Data Models

### User Model
```dart
class UserModel {
  final String name;
  final String email;
  final String avatar;
}
```

### Course Model
```dart
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
  final double? progress;
  final double price;
  final String level;
  final double? discountPrice;
}
```

### Lesson Model
```dart
class Lesson {
  final String id;
  final String slug;
  final String title;
  final String content;
  final String? videoUrl;
  final int? videoDuration;
  final bool isFreePreview;
}
```

### Category Model
```dart
class Category {
  final String name;
  final IconData icon;
}
```

---

## Feature Development Guidelines

### Adding New Features
1. Create model classes in `lib/models/`
2. Implement API service methods in `lib/services/`
3. Build UI screens in `lib/screens/`
4. Create reusable widgets in `lib/widgets/`
5. Write unit tests in `test/` directory
6. Document the feature in this file

### Code Organization
- **Models**: Data structures and classes
- **Services**: API calls and business logic
- **Screens**: Complete page/view implementations
- **Widgets**: Reusable UI components and utilities
- **Utils**: Constants, colors, helper functions

---

## Authentication Flow

```
Launch App
    ↓
Check Token in SharedPreferences
    ↓
Token Exists?
    ├─ Yes → HomeScreen (Authenticated)
    └─ No → LoginScreen (Not Authenticated)
         ↓
      Sign In / Sign Up
         ↓
      Verify Credentials
         ↓
      Store Token
         ↓
      Navigate to HomeScreen
```

---

## API Integration

All API calls are handled through `ApiService` which uses Dio for HTTP requests.

**Base URL**: `https://e-learning-api-production-a6d4.up.railway.app/api`

**Key Endpoints**:
- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `GET /courses` - Fetch all courses
- `GET /courses/{id}` - Get course details
- `POST /courses/{id}/enroll` - Enroll in course
- `GET /user/profile` - Get user profile
- `PUT /user/profile` - Update user profile

---

## Technology Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform mobile framework |
| **Dart** | Programming language |
| **Dio** | HTTP client for API calls |
| **SharedPreferences** | Local data persistence |
| **Intl** | Internationalization |
| **URL Launcher** | Open URLs |
| **Video Player** | Play course videos |

---

## Best Practices

1. **Error Handling**: All API calls should include try-catch blocks
2. **Loading States**: Show loading indicators during async operations
3. **User Feedback**: Display SnackBars or Dialogs for user feedback
4. **Resource Management**: Dispose controllers and streams properly
5. **Responsive Design**: Ensure UI works across different screen sizes
6. **Testing**: Write unit and widget tests for critical features
7. **Code Comments**: Document complex logic and algorithms

---

## Future Enhancements

- [ ] Offline mode with local caching
- [ ] Push notifications
- [ ] Video download for offline viewing
- [ ] Live instructor sessions
- [ ] Gamification (badges, certificates)
- [ ] Community forums
- [ ] Advanced analytics dashboard
- [ ] Social sharing features
- [ ] Subscription model
- [ ] AI-powered recommendations

---

## Support & Maintenance

For issues, feature requests, or questions:
1. Check existing issues on GitHub
2. Review this documentation
3. Contact the development team
4. Check the Help Center in the app

