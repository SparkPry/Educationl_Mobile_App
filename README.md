# 📚 Educational Mobile App

A comprehensive, cross-platform educational application built with Flutter that connects students with mentors, courses, and interactive learning experiences.

## 🌟 Features

### Core Features
- **🔐 Authentication System**
  - User registration and login
  - Password reset with email verification
  - Secure token-based authentication
  - Profile management and editing

- **📚 Course Management**
  - Browse and search thousands of courses
  - Course categories and filtering
  - Course details with curriculum and lessons
  - Progress tracking for enrolled courses
  - Top-rated course recommendations

- **👨‍🏫 Mentor System**
  - Browse detailed mentor profiles
  - View mentor expertise and ratings
  - Read student reviews and testimonials
  - Direct messaging with mentors
  - Schedule consultations with mentors

- **💬 Messaging & Communication**
  - Direct messaging with mentors and peers
  - Chat history and conversation management
  - Search through messages
  - Filter by unread/read status
  - Real-time message notifications

- **🎓 Learning Experience**
  - Interactive lesson viewing
  - Video content streaming
  - Quiz and assessments
  - Learning progress tracking
  - Certificate upon completion

- **💳 Payment Integration**
  - Secure payment methods
  - Course enrollment via payment
  - Payment history and receipts
  - Discount and promotional codes
  - Multiple payment options

- **🔔 Notifications**
  - Course updates and announcements
  - Message notifications
  - Payment confirmations
  - Learning reminders

- **📱 Additional Features**
  - Personalized dashboard
  - My Courses section
  - Help Center and Support
  - Privacy Policy and Terms
  - User Profile customization

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider/Riverpod
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences, SQLite
- **UI Components**: Material Design 3

### Backend
- **API**: RESTful API
- **Email Service**: SMTP Integration (for password reset)
- **Database**: PostgreSQL/MongoDB
- **Authentication**: JWT Token-based

### Platforms Supported
- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher)
  - Download: https://flutter.dev/docs/get-started/install
  
- **Dart SDK** (included with Flutter)

- **IDE/Editor**
  - Visual Studio Code with Flutter extension
  - Android Studio
  - Xcode (for iOS development)

- **Emulator/Device**
  - Android Emulator or physical Android device
  - iOS Simulator or physical iOS device

## 🚀 Getting Started

### 1. **Clone the Repository**
```bash
git clone https://github.com/SparkPry/Educationl_Mobile_App.git
cd Educationl_Mobile_App
```

### 2. **Switch to Development Branch**
```bash
git checkout Puthyseth
```

### 3. **Install Dependencies**
```bash
flutter pub get
```

### 4. **Configure Environment (if needed)**
Create a `.env` file in the project root:
```
API_BASE_URL=https://your-api-endpoint.com
API_TIMEOUT=30000
```

### 5. **Run the App**

**For Android:**
```bash
flutter run -d android
```

**For iOS:**
```bash
flutter run -d ios
```

**For Web:**
```bash
flutter run -d chrome
```

**For Desktop (Windows/macOS/Linux):**
```bash
flutter run -d windows
# or
flutter run -d macos
# or
flutter run -d linux
```

### 6. **Build for Production**

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## 📁 Project Structure

```
Educationl_Mobile_App/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/                  # Screen pages
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── course_screen.dart
│   │   ├── mentor_profile_screen.dart
│   │   ├── inbox_screen.dart
│   │   ├── profile_screen.dart
│   │   └── ...
│   ├── models/                   # Data models
│   │   ├── course_model.dart
│   │   ├── mentor_model.dart
│   │   ├── chat_model.dart
│   │   └── ...
│   ├── services/                 # API & Business logic
│   │   ├── api_service.dart
│   │   ├── course_api_service.dart
│   │   └── ...
│   ├── widgets/                  # Reusable widgets
│   │   ├── course_card.dart
│   │   ├── chat_item_widget.dart
│   │   └── ...
│   ├── data/                     # Local data & constants
│   │   ├── course_data.dart
│   │   ├── mentor_data.dart
│   │   └── ...
│   ├── utils/                    # Utilities & helpers
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── ...
│   └── assets/                   # Static assets
│       ├── images/
│       └── ...
├── test/                         # Unit & Widget tests
│   ├── widget_test.dart
│   ├── models/
│   ├── screens/
│   └── services/
├── android/                      # Android native code
├── ios/                          # iOS native code
├── web/                          # Web platform code
├── windows/                      # Windows native code
├── macos/                        # macOS native code
├── linux/                        # Linux native code
├── pubspec.yaml                  # Dependencies & configuration
├── analysis_options.yaml         # Lint rules
└── README.md                     # This file
```

## 📖 Documentation

- [API Documentation](API_DOCUMENTATION.md) - Complete API reference
- [Code Standards](CODE_STANDARDS.md) - Coding guidelines and conventions
- [Testing Guide](TESTING_GUIDE.md) - Testing procedures and best practices
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md) - Feature implementation details
- [Features](FEATURES.md) - Detailed feature descriptions
- [Quick Start](QUICKSTART.md) - Quick setup guide
- [Troubleshooting](troubleshooting.md) - Common issues and solutions

## 🔐 Authentication

### Login Flow
1. User enters email and password
2. Credentials sent to API via `ApiService`
3. JWT token received and stored in SharedPreferences
4. Token validated on app startup
5. If expired, user redirected to login screen

### Registration
1. User fills registration form
2. Email verification sent
3. Account created upon verification
4. User can now login

## 📱 Key Screens

| Screen | Purpose |
|--------|---------|
| **Splash Screen** | App initialization and token validation |
| **Onboarding** | First-time user introduction |
| **Home Screen** | Dashboard with recommended courses and mentors |
| **Course Screen** | Course details and curriculum |
| **Mentor Profile** | Mentor information and reviews |
| **Inbox** | Messages and conversations |
| **My Courses** | Enrolled courses and progress |
| **Profile** | User information and settings |
| **Login** | User authentication |
| **Payment** | Course enrollment and payments |

## 🔌 API Integration

The app uses a RESTful API for backend communication. Key endpoints:

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /profile` - Get user profile
- `GET /courses` - List courses
- `GET /courses/:id` - Course details
- `GET /mentors` - List mentors
- `GET /mentors/:id` - Mentor profile
- `POST /messages` - Send message
- `GET /messages` - Get conversations

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for complete details.

## 🧪 Testing

Run tests with:

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/screens/home_screen_test.dart
```

See [TESTING_GUIDE.md](TESTING_GUIDE.md) for more information.

## 📊 Code Quality

We maintain high code quality standards:

- **Static Analysis**: `dart analyze`
- **Formatting**: `dart format`
- **Linting**: Follow `analysis_options.yaml`

Run analysis:
```bash
flutter analyze
```

Format code:
```bash
dart format lib/
```

## 🐛 Known Issues & Troubleshooting

See [troubleshooting.md](troubleshooting.md) for common issues and solutions.

## 🔄 State Management

The app uses a mix of:
- **StatefulWidget** for local state
- **Provider/Riverpod** for global state (when scaled)
- **SharedPreferences** for persistence

## 🎨 Theming

The app uses Material Design 3 with custom theme colors defined in `utils/app_colors.dart`:

- **Primary Color**: `#6B66FF` (Purple)
- **Secondary Color**: Defined in `AppColors`
- **Background**: Light gray (`#F6F6F6`)

## 📦 Dependencies

Key packages used:
- `http` / `dio` - API calls
- `shared_preferences` - Local storage
- `flutter_dotenv` - Environment variables
- `cached_network_image` - Image caching
- `intl` - Internationalization
- `provider` - State management (if used)

See `pubspec.yaml` for complete list.

## 🚦 Git Workflow

```bash
# Main branch (production)
main

# Development branch
Puthyseth

# Feature branches
feature/feature-name
bugfix/bug-name
```

## 💡 Best Practices

1. **Code Organization**: Keep related code in appropriate directories
2. **Naming Conventions**: Follow Dart style guide
3. **Documentation**: Document complex functions and classes
4. **Error Handling**: Always handle potential errors with try-catch
5. **Performance**: Use `const` constructors and lazy loading
6. **Accessibility**: Support screen readers and keyboard navigation

## 🐛 Bug Reports

Found a bug? Please:
1. Check [troubleshooting.md](troubleshooting.md) first
2. Search existing issues on GitHub
3. Create a new issue with:
   - Bug description
   - Steps to reproduce
   - Expected vs actual behavior
   - Device/OS information
   - Logs/screenshots if available

## 🤝 Contributing

We welcome contributions! Please:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/your-feature`
3. **Commit changes**: `git commit -am 'Add your feature'`
4. **Push to branch**: `git push origin feature/your-feature`
5. **Submit a Pull Request**

See [CODE_STANDARDS.md](CODE_STANDARDS.md) for coding guidelines.

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 👥 Team

- **Project Owner**: SparkPry
- **Repository**: https://github.com/SparkPry/Educationl_Mobile_App

## 📧 Support

For support, documentation, and questions:
- Check [QUICKSTART.md](QUICKSTART.md) for quick setup
- Review [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for API details
- Visit [troubleshooting.md](troubleshooting.md) for common issues
- See [FEATURES.md](FEATURES.md) for detailed feature information

## 🎯 Roadmap

### Phase 1 (Current)
- ✅ Core authentication
- ✅ Course browsing
- ✅ Mentor profiles
- ✅ Messaging system
- ✅ Payment integration

### Phase 2 (Upcoming)
- [ ] Live video classes
- [ ] Advanced progress analytics
- [ ] Peer-to-peer learning groups
- [ ] Gamification and badges
- [ ] AI-powered course recommendations

### Phase 3 (Future)
- [ ] Mobile app push notifications
- [ ] Offline mode support
- [ ] Social network features
- [ ] Corporate training management
- [ ] Advanced reporting and analytics

## 🙏 Acknowledgments

- Flutter community for excellent documentation
- All contributors and testers
- Open-source packages used in this project

---

**Last Updated**: February 2026  
**Version**: 1.0.0  
**Status**: Active Development

For more information, visit the [project documentation](DOCUMENTATION_INDEX.md).
