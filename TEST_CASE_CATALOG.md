# Test Case Catalog & Coverage

## Overview
This document catalogs all test cases in the Education App and their purposes. Use this to understand test coverage and identify areas that need additional testing.

---

## Test Execution Commands

### Run All Tests
```bash
flutter test
```

### Run Tests by Category
```bash
# Run all model tests
flutter test test/models/

# Run all service tests
flutter test test/services/

# Run all screen tests
flutter test test/screens/

# Run specific test file
flutter test test/models/user_model_test.dart -v
```

### Generate Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

## Unit Tests

### Models

#### UserModel Tests (`test/models/user_model_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `UserModel should be created with correct properties` | Verify UserModel initialization with name, email, avatar | User object created with matching properties |
| `UserModel should handle empty strings` | Verify UserModel handles empty string values | Empty strings properly stored |
| `UserModel with valid email format` | Verify email contains @ symbol | Email validation passes |
| `Multiple UserModel instances should be independent` | Verify instances don't share data | Each instance has unique values |

**Run Command:**
```bash
flutter test test/models/user_model_test.dart -v
```

---

#### CourseModel Tests (`test/models/course_model_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `Course should be created with correct properties` | Verify Course object initialization | All properties correctly assigned |
| `Course should support optional progress tracking` | Verify optional progress property | Progress value properly stored |
| `Course should support discount price` | Verify optional discount pricing | Discount price less than original |
| `Lesson should be created with required properties` | Verify Lesson initialization | Lesson object created successfully |
| `Lesson should support video content` | Verify video properties (URL, duration, free preview) | Video properties properly handled |
| `Instructor should be created with correct properties` | Verify Instructor object initialization | All instructor properties assigned |
| `Overview should contain all required information` | Verify Overview model structure | All sections populated correctly |

**Run Command:**
```bash
flutter test test/models/course_model_test.dart -v
```

---

### Services

#### ApiService Tests (`test/services/api_service_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `ApiService should initialize with correct base URL` | Verify API base URL configuration | Base URL matches expected value |
| `ApiService should have correct default headers` | Verify Content-Type header | Header is application/json |
| `login should send correct payload` | Verify login method exists and callable | Method callable without errors |
| `register should send correct payload` | Verify register method exists and callable | Method callable without errors |
| `ApiService should add Authorization header with token` | Verify token injection in requests | Authorization interceptor present |
| `login should throw DioException on invalid credentials` | Verify error handling for invalid credentials | DioException thrown appropriately |
| `register should handle network errors gracefully` | Verify network error handling | Errors handled without crashing |

**Run Command:**
```bash
flutter test test/services/api_service_test.dart -v
```

---

## Widget Tests

### Screens

#### LoginScreen Tests (`test/screens/login_screen_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `LoginScreen should display Sign In and Sign Up toggle buttons` | Verify toggle buttons visible | Both buttons rendered |
| `LoginScreen should display welcome text` | Verify greeting messages | "Hello there," and welcome message displayed |
| `LoginScreen should display email input field` | Verify email input widget | Email input field visible |
| `LoginScreen should display password input field` | Verify password input widget | Password input field visible |
| `LoginScreen should show forgot password button in Sign In mode` | Verify forgot password button | Button visible in Sign In mode |
| `LoginScreen should toggle between Sign In and Sign Up modes` | Verify mode switching | Username field appears/disappears appropriately |
| `LoginScreen should display username field in Sign Up mode` | Verify username field in Sign Up | Username field rendered |
| `LoginScreen should hide username field in Sign In mode` | Verify username field hidden in Sign In | No username field in Sign In mode |
| `LoginScreen text fields should be editable` | Verify text input capability | Text can be entered in fields |

**Run Command:**
```bash
flutter test test/screens/login_screen_test.dart -v
```

---

#### HomeScreen Tests (`test/screens/home_screen_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `HomeScreen should render without errors` | Verify HomeScreen initialization | Widget renders successfully |
| `HomeScreen should be a StatefulWidget` | Verify widget type | HomeScreen is StatefulWidget |
| `HomeScreen should display properly on initialization` | Verify proper rendering | No runtime errors |

**Run Command:**
```bash
flutter test test/screens/home_screen_test.dart -v
```

---

#### CourseScreen Tests (`test/screens/course_screen_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `CourseScreen should render without errors` | Verify CourseScreen initialization | Widget renders successfully |
| `CourseScreen should have a Scaffold` | Verify main structure | Scaffold widget present |
| `CourseScreen should display course content` | Verify content rendering | ScrollView with content visible |

**Run Command:**
```bash
flutter test test/screens/course_screen_test.dart -v
```

---

#### Widget Tests (`test/widget_test.dart`)
| Test Case | Description | Expected Result |
|-----------|-------------|-----------------|
| `Splash screen shows app name and navigates to onboarding` | Verify splash screen flow | "AngkorEdu" displayed, navigates to OnboardingScreen |

**Run Command:**
```bash
flutter test test/widget_test.dart -v
```

---

## Test Coverage Summary

### By Category
| Category | Total Tests | Coverage |
|----------|------------|----------|
| Models | 11 | Unit tests for data structures |
| Services | 7 | API service integration tests |
| Screens | 13 | Widget tests for UI components |
| **Total** | **31** | **Core functionality** |

### By Type
| Type | Count | Purpose |
|------|-------|---------|
| Unit Tests | 18 | Test models and services in isolation |
| Widget Tests | 13 | Test UI components and interactions |
| Integration Tests | 1 | Test navigation and app flow |

---

## Test Execution Strategy

### Local Development
```bash
# Run tests before committing
flutter test

# Run with coverage
flutter test --coverage
```

### Continuous Integration
Tests are run automatically on pull requests via GitHub Actions.

### Manual Testing Phases

#### Phase 1: Authentication
1. Test user registration
2. Test user login
3. Test password recovery
4. Test session persistence

#### Phase 2: Course Discovery
1. Test course listing
2. Test course filtering
3. Test search functionality
4. Test course details

#### Phase 3: Learning
1. Test lesson navigation
2. Test video playback
3. Test progress tracking
4. Test quiz functionality

#### Phase 4: Payments
1. Test payment method selection
2. Test transaction processing
3. Test receipt generation

#### Phase 5: User Management
1. Test profile viewing
2. Test profile editing
3. Test settings modification

---

## Adding New Tests

### New Model Tests
1. Create file: `test/models/model_name_test.dart`
2. Follow pattern from existing model tests
3. Test initialization, edge cases, and error conditions
4. Run: `flutter test test/models/model_name_test.dart`

### New Service Tests
1. Create file: `test/services/service_name_test.dart`
2. Mock external dependencies (Dio, etc.)
3. Test API calls and error handling
4. Run: `flutter test test/services/service_name_test.dart`

### New Screen Tests
1. Create file: `test/screens/screen_name_test.dart`
2. Test widget rendering and user interactions
3. Test navigation and state changes
4. Run: `flutter test test/screens/screen_name_test.dart`

### Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Name Tests', () {
    setUp(() {
      // Initialize test data
    });

    test('should do something', () {
      // Arrange
      final data = TestData();
      
      // Act
      final result = data.method();
      
      // Assert
      expect(result, equals(expectedValue));
    });

    testWidgets('widget should display', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(testWidget);
      
      // Assert
      expect(find.text('Expected'), findsOneWidget);
    });
  });
}
```

---

## Debugging Tests

### Verbose Output
```bash
flutter test -v
```

### Single Test Execution
```bash
flutter test test/models/user_model_test.dart::UserModel Tests::UserModel should be created
```

### Pause on Error
```bash
flutter test --start-paused
```

### Watch Mode
```bash
flutter test --watch
```

---

## Performance Benchmarks

### Expected Test Execution Times
- Unit Tests: <1s per test
- Widget Tests: 2-5s per test
- Full Test Suite: <60s total

### Target Coverage Goals
- Overall: >80%
- Models: 100%
- Services: 90%+
- Screens: 70%+

---

## Continuous Improvement

### Regular Review Tasks
- [ ] Review test coverage monthly
- [ ] Update tests when features change
- [ ] Add tests for bug fixes
- [ ] Remove obsolete tests
- [ ] Refactor slow tests

### Test Maintenance
- Keep test data accurate
- Remove duplicate tests
- Consolidate similar tests
- Update documentation

---

## Resources

- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [Dart Testing Guide](https://dart.dev/guides/testing)
- [Widget Testing Samples](https://flutter.dev/docs/testing/unit-tests)
- [Mockito Package](https://pub.dev/packages/mockito)

