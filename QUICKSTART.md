# Quick Start Guide

## Getting Started with AngkorEdu

This guide will help you quickly set up and run the Education App.

---

## System Requirements

- **Flutter**: 3.10.0 or higher
- **Dart**: 3.0.0 or higher
- **Android**: API level 21 or higher
- **iOS**: iOS 11.0 or higher
- **RAM**: Minimum 4GB
- **Disk Space**: 2GB for Android development, 3GB for iOS

---

## Installation (5 minutes)

### Step 1: Install Flutter & Dart
If not already installed:
```bash
# macOS
brew install flutter

# Windows (using Chocolatey)
choco install flutter

# Or download from flutter.dev
```

### Step 2: Verify Installation
```bash
flutter doctor
```

Expected output:
```
✓ Flutter (Channel stable)
✓ Android toolchain
✓ Xcode (for iOS)
✓ VS Code
```

### Step 3: Clone Repository
```bash
git clone https://github.com/SparkPry/Educationl_Mobile_App.git
cd Educationl_Mobile_App
```

### Step 4: Install Dependencies
```bash
flutter pub get
```

---

## Running the App (2 minutes)

### Option 1: Android Emulator
```bash
# Start emulator
emulator -avd Pixel_4_API_30

# Run app
flutter run
```

### Option 2: iOS Simulator
```bash
# Start simulator
open -a Simulator

# Run app
flutter run
```

### Option 3: Physical Device
1. Enable USB Debugging on your device
2. Connect via USB
3. Run: `flutter run`

### Option 4: Web
```bash
flutter run -d chrome
```

---

## First Test Login

**Test Credentials:**
```
Email:    user@example.com
Password: password123
```

**Test User Actions:**
1. Login with test credentials
2. Browse courses on Home screen
3. View course details
4. Check My Courses
5. Logout (if implemented)

---

## Running Tests (2 minutes)

### Quick Test
```bash
flutter test
```

### Test Specific Feature
```bash
# User model tests
flutter test test/models/user_model_test.dart

# Login screen tests
flutter test test/screens/login_screen_test.dart

# All service tests
flutter test test/services/
```

### View Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## Common Commands

```bash
# Get latest dependencies
flutter pub get

# Format code
dart format lib/

# Analyze code
flutter analyze

# Clean project
flutter clean

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Check Flutter setup
flutter doctor -v
```

---

## Project Navigation

After running `flutter run`, you can navigate:

1. **Login Screen** (Initial)
   - Email: user@example.com
   - Password: password123
   - Sign Up option available

2. **Home Screen** (After Login)
   - Featured courses
   - Categories
   - Search option
   - Bottom navigation

3. **Course Screen**
   - Course details
   - Instructor info
   - Curriculum
   - Enroll button

4. **My Courses**
   - Enrolled courses
   - Progress tracking
   - Continue learning

5. **Profile Screen**
   - User information
   - Settings
   - Logout

---

## Troubleshooting

### Flutter not found
```bash
# Add Flutter to PATH
export PATH="$PATH:$HOME/flutter/bin"
```

### Pub cache issues
```bash
flutter pub get
flutter clean
flutter pub get
```

### Build issues
```bash
flutter clean
flutter pub get
flutter run
```

### Permission denied (macOS/Linux)
```bash
chmod +x android/gradlew
```

### Xcode license issues (macOS)
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

---

## Directory Structure Quick Reference

```
Educationl_Mobile_App/
├── lib/
│   ├── main.dart              ← App entry point
│   ├── screens/               ← All UI screens
│   ├── models/                ← Data models
│   ├── services/              ← API calls
│   ├── widgets/               ← Reusable components
│   └── utils/                 ← Constants/helpers
├── test/
│   ├── models/                ← Model tests
│   ├── services/              ← Service tests
│   └── screens/               ← UI tests
├── pubspec.yaml               ← Dependencies
├── README.md                  ← Full documentation
├── FEATURES.md                ← Feature details
├── API_DOCUMENTATION.md       ← API endpoints
└── TESTING_GUIDE.md          ← Testing help
```

---

## Next Steps

1. **Understand the Architecture**
   - Read [FEATURES.md](FEATURES.md)
   - Review main screens in `lib/screens/`

2. **Add Your Own Features**
   - Create new screen in `lib/screens/`
   - Add corresponding test in `test/screens/`
   - Update documentation

3. **Connect Real API**
   - Update `API_DOCUMENTATION.md`
   - Test endpoints in `lib/services/api_service.dart`

4. **Deploy Your App**
   - Android: `flutter build apk --release`
   - iOS: `flutter build ios --release`

---

## Documentation Links

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Full project documentation |
| [FEATURES.md](FEATURES.md) | Feature descriptions |
| [API_DOCUMENTATION.md](API_DOCUMENTATION.md) | API reference |
| [TESTING_GUIDE.md](TESTING_GUIDE.md) | Testing procedures |
| [TEST_CASE_CATALOG.md](TEST_CASE_CATALOG.md) | Test cases |
| [troubleshooting.md](troubleshooting.md) | Common issues |

---

## Getting Help

### Common Questions
- "How do I change the API URL?" → See [API_DOCUMENTATION.md](API_DOCUMENTATION.md)
- "How do I run tests?" → See [TESTING_GUIDE.md](TESTING_GUIDE.md)
- "What features are available?" → See [FEATURES.md](FEATURES.md)
- "I have an issue" → Check [troubleshooting.md](troubleshooting.md)

### Useful Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [GitHub Issues](https://github.com/SparkPry/Educationl_Mobile_App/issues)

---

## Tips for Success

✅ **Do:**
- Read the documentation before starting
- Run tests before making changes
- Use meaningful commit messages
- Keep code formatting consistent
- Test on both Android and iOS

❌ **Don't:**
- Ignore error messages
- Skip writing tests
- Hardcode values
- Mix business logic with UI
- Commit without testing

---

## What's Next?

🎉 Great! You're ready to develop with AngkorEdu!

1. Explore the [FEATURES.md](FEATURES.md) to understand the architecture
2. Check [TESTING_GUIDE.md](TESTING_GUIDE.md) to write your own tests
3. Review [API_DOCUMENTATION.md](API_DOCUMENTATION.md) to integrate endpoints
4. Start building your features!

---

**Happy Coding! 🚀**

For more help, check the full [README.md](README.md)
