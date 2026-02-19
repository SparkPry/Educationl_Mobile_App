# Code Standards & Documentation Guidelines

## Overview
This document outlines the coding standards, documentation practices, and best practices for the AngkorEdu project.

---

## Code Style Guide

### Dart/Flutter Conventions

#### Naming Conventions
```dart
// Classes: UpperCamelCase
class UserModel { }
class LoginScreen extends StatefulWidget { }

// Functions/Methods: lowerCamelCase
void getUserData() { }
Future<Response> loginUser(String email) { }

// Variables: lowerCamelCase
final userName = 'John';
const apiBaseUrl = 'https://api.example.com';

// Constants: lowerCamelCase with const prefix
const int maxRetries = 3;
const String appName = 'AngkorEdu';

// Private members: _lowerCamelCase
String _privateVariable;
void _privateMethod() { }

// Enums: lowerCamelCase enum values
enum UserRole {
  admin,
  instructor,
  student,
}
```

#### Imports Organization
```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Package imports
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 4. Relative imports
import 'models/user_model.dart';
import 'services/api_service.dart';
import 'utils/app_colors.dart';
```

---

## Documentation Standards

### Class Documentation
```dart
/// A widget that displays the login screen with sign in/up functionality.
/// 
/// This stateful widget manages the authentication flow, handling both
/// user login and registration. It communicates with [ApiService] to
/// authenticate users and stores the received token using [SharedPreferences].
/// 
/// See also:
///   * [ApiService], which handles API communication
///   * [ForgotPasswordScreen], for password recovery
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen] widget.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
```

### Method Documentation
```dart
/// Updates the user's profile information on the server.
/// 
/// Sends a PUT request to the /user/profile endpoint with the provided
/// [userData]. Returns the updated [UserModel] on success.
/// 
/// Throws [DioException] if the API call fails.
/// 
/// Parameters:
///   * [userData]: Map containing updated user information (name, bio, avatar)
/// 
/// Returns:
///   A [Future] that resolves to the updated [UserModel]
/// 
/// Example:
/// ```dart
/// final updatedUser = await apiService.updateProfile({'name': 'John Doe'});
/// ```
Future<UserModel> updateProfile(Map<String, dynamic> userData) async {
  // Implementation
}
```

### Parameter Documentation
```dart
/// Authenticate a user with email and password.
/// 
/// [email] must be a valid email format.
/// [password] must be at least 6 characters long.
/// 
/// Returns a response containing the auth token.
Future<Response> login({
  /// The user's email address
  required String email,
  /// The user's password
  required String password,
}) async {
  // Implementation
}
```

---

## File Organization

### Screen Files
```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

/// Brief description of the screen
class ScreenNameScreen extends StatefulWidget {
  const ScreenNameScreen({Key? key}) : super(key: key);

  @override
  State<ScreenNameScreen> createState() => _ScreenNameScreenState();
}

class _ScreenNameScreenState extends State<ScreenNameScreen> {
  // Private fields
  late ApiService _apiService;
  late TextEditingController _controller;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    // Implementation
  }

  Future<void> _handleAction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Business logic
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen Title')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Text('Content'),
    );
  }
}
```

### Model Files
```dart
/// Represents a user in the application.
class UserModel {
  /// Unique identifier for the user
  final String id;

  /// User's full name
  final String name;

  /// User's email address
  final String email;

  /// URL to user's profile avatar
  final String avatar;

  /// Creates a [UserModel] instance.
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  /// Creates a [UserModel] from JSON data.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String? ?? '',
    );
  }

  /// Converts this [UserModel] to JSON.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
  };
}
```

### Service Files
```dart
/// Handles all API communication with the backend.
class ApiService {
  /// Creates an [ApiService] instance with Dio configuration.
  ApiService() {
    // Initialize Dio with base options
  }

  /// Authenticates a user with email and password.
  ///
  /// Returns a [Response] containing the authentication token.
  /// Throws [DioException] on authentication failure.
  Future<Response> login(String email, String password) async {
    try {
      return await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Unexpected error during login');
    }
  }
}
```

---

## Comments Best Practices

### Good Comments
```dart
// Do: Explain why, not what
// User must be re-authenticated after 30 minutes of inactivity
// for security compliance with company policy
if (sessionExpired) {
  _logout();
}

// Do: Explain complex algorithms
// Using quicksort for O(n log n) average time complexity
// instead of bubble sort O(n²) for better performance
List<Course> sortCourses(List<Course> courses) {
  // Implementation
}

// Do: Document workarounds
// TODO: Remove this workaround when Dio v6.0 is released
// See: https://github.com/dio/dio/issues/xxxx
if (platform == TargetPlatform.windows) {
  // Workaround code
}
```

### Bad Comments
```dart
// Don't: State the obvious
int count = 0; // Initialize count to 0

// Don't: Comment out code (use version control instead)
// final response = await apiService.login(email, password);

// Don't: Write misleading comments
// This calculates the user's age (actually gets days since signup)
int age = today.difference(signupDate).inDays;
```

---

## Error Handling Standards

### Consistent Error Handling Pattern
```dart
try {
  // API call
  final response = await apiService.login(email, password);
  
  // Handle success
  _handleLoginSuccess(response);
} on DioException catch (e) {
  // Handle network/API errors
  setState(() {
    _errorMessage = e.response?.data['message'] ?? 
                   'Network error occurred';
  });
} on FormatException catch (e) {
  // Handle parsing errors
  setState(() {
    _errorMessage = 'Invalid data format received';
  });
  debugPrint('Parse error: $e');
} catch (e) {
  // Handle unexpected errors
  setState(() {
    _errorMessage = 'An unexpected error occurred';
  });
  debugPrint('Unexpected error: $e');
}
```

### User-Friendly Error Messages
```dart
// Do: Show user-friendly messages
"Unfortunately, we couldn't connect to the server. Please check your internet connection and try again."

// Don't: Show technical error details
"DioException: Failed to establish network connection. Error code: ECONNREFUSED"

// Show technical details in logs, not UI
debugPrint('API Error: $technicalsException');
```

---

## Testing Standards

### Test Naming Conventions
```dart
// Good test names
test('login should succeed with valid credentials', () { });
test('course should have discount if discountPrice < price', () { });
test('LoginScreen should display email input field', () { });

// Bad test names
test('test login', () { });
test('course test', () { });
test('screen renders', () { });
```

### Test Documentation
```dart
/// Tests for the [Course] model class.
/// 
/// These tests verify:
/// - Course initialization with all properties
/// - Optional property handling (progress, discount)
/// - Model equality and validation logic
void main() {
  group('Course Model Tests', () {
    test('should create course with all properties', () {
      // Arrange
      
      // Act
      
      // Assert
    });
  });
}
```

---

## Code Review Checklist

Before submitting a pull request, ensure:

### Code Quality
- [ ] Follows naming conventions
- [ ] No hardcoded values (use constants)
- [ ] Proper error handling
- [ ] No commented-out code
- [ ] No debug prints in production code
- [ ] Imports are organized and sorted

### Documentation
- [ ] Classes have documentation comments
- [ ] Public methods have documentation
- [ ] Complex logic has explanatory comments
- [ ] TODO/FIXME items are tracked

### Testing
- [ ] Unit tests for new models/services
- [ ] Widget tests for new UI components
- [ ] Tests cover normal and edge cases
- [ ] All tests pass locally
- [ ] Coverage hasn't decreased

### Performance
- [ ] No unnecessary rebuilds
- [ ] Proper resource disposal
- [ ] No memory leaks
- [ ] Efficient algorithms

### Security
- [ ] API tokens not logged
- [ ] Passwords not displayed
- [ ] Input validation for user data
- [ ] HTTPS only for API calls

---

## Git Commit Standards

### Commit Message Format
```
<type>: <subject>

<body>

<footer>
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **test**: Adding/updating tests
- **refactor**: Code refactoring
- **style**: Code style (formatting, etc.)
- **chore**: Build process, dependencies

### Examples
```
feat: add course video playback functionality

Implement video player widget with play/pause controls
and progress tracking for course lessons.

Closes #123
```

```
fix: resolve login token persistence issue

Fix SharedPreferences not saving token properly after
successful authentication. Add proper null checks.

Fixes #456
```

---

## Performance Guidelines

### Widget Building
```dart
// Good: Use const constructors
const Text('Hello'), // Const constructor
const ListView(...),

// Bad: Unnecessary rebuilds
Text('Hello'), // Rebuilds unnecessarily
ListView(...)
```

### State Management
```dart
// Good: Minimize rebuilds
setState(() {
  _specificField = newValue;
});

// Bad: Rebuild entire widget
setState(() {
  // Update many variables at once
});
```

### Resource Management
```dart
// Good: Proper disposal
@override
void dispose() {
  _controller.dispose();
  _animationController.dispose();
  _subscription.cancel();
  super.dispose();
}

// Bad: Memory leaks
// Missing dispose calls
```

---

## Accessibility Standards

### Color Contrast
- Minimum WCAG AA contrast ratio: 4.5:1 for text
- Use [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

### Text Size
- Minimum font size: 12sp
- Use semantic text sizes (headline, bodyText2, etc.)

### Touch Targets
- Minimum touch target: 48dp x 48dp
- Proper spacing between interactive elements

```dart
// Good: Accessible button
InkWell(
  onTap: () {},
  child: Container(
    width: 48,
    height: 48,
    child: Icon(Icons.add),
  ),
)

// Bad: Too small touch target
InkWell(
  onTap: () {},
  child: Icon(Icons.close), // Only 24x24dp
)
```

---

## Localization Standards

All UI strings should be localized:

```dart
// Good: Use localization
Text(context.l10n.loginTitle)

// Bad: Hardcoded strings
Text('Login')
```

---

## Security Best Practices

### Never Log Sensitive Data
```dart
// Bad: Exposes sensitive information
debugPrint('Token: $token');
debugPrint('Password: $password');

// Good: Safe logging
debugPrint('Login attempt for: ${email.split('@')[0]}');
if (kDebugMode) {
  debugPrint('Token length: ${token.length}');
}
```

### Validate Input
```dart
// Good: Validate before use
if (_validateEmail(email) && _validatePassword(password)) {
  await login(email, password);
}

// Bad: No validation
await login(email, password);
```

---

## Resources

- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Material Design Guidelines](https://material.io/design)
- [WCAG Accessibility](https://www.w3.org/WAI/WCAG21/quickref/)

