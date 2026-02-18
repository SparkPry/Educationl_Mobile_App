# Testing Guide

## Overview
This guide explains how to run tests for the Education App, covering unit tests, widget tests, and integration testing best practices.

---

## Test Structure

The project follows a standard Flutter test structure:

```
test/
├── models/
│   ├── user_model_test.dart
│   ├── course_model_test.dart
│   └── ...
├── services/
│   ├── api_service_test.dart
│   └── course_api_service_test.dart
├── screens/
│   ├── login_screen_test.dart
│   ├── home_screen_test.dart
│   ├── course_screen_test.dart
│   └── ...
└── widget_test.dart
```

---

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Run Specific Test File
```bash
flutter test test/models/user_model_test.dart
```

### Run Tests with Pattern
```bash
flutter test test/models/
```

### Run Tests in Watch Mode
```bash
flutter test --watch
```

### Run Tests with Verbose Output
```bash
flutter test -v
```

---

## Test Types

### 1. Unit Tests
Test individual functions, classes, and models in isolation.

**Example: User Model Test**
```dart
test('UserModel should be created with correct properties', () {
  // Arrange
  const name = 'John Doe';
  const email = 'john@example.com';
  final user = UserModel(
    name: name,
    email: email,
    avatar: 'avatar.jpg',
  );
  
  // Act & Assert
  expect(user.name, equals(name));
  expect(user.email, equals(email));
});
```

**Running Unit Tests:**
```bash
flutter test test/models/
```

### 2. Widget Tests
Test UI widgets and their interactions.

**Example: Login Screen Test**
```dart
testWidgets('LoginScreen should display welcome text', (tester) async {
  // Act
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  
  // Assert
  expect(find.text('Hello there,'), findsOneWidget);
});
```

**Running Widget Tests:**
```bash
flutter test test/screens/
```

### 3. Integration Tests
Test complete user workflows and app navigation.

**Example: Authentication Flow**
```dart
testWidgets('User can login and navigate to home', (tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Enter credentials
  await tester.enterText(find.byType(TextField).first, 'user@example.com');
  await tester.enterText(find.byType(TextField).last, 'password');
  
  // Tap login
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
  
  // Assert navigation
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

---

## Testing Best Practices

### 1. Arrange-Act-Assert Pattern
```dart
test('description', () {
  // Arrange - Setup test data
  final user = UserModel(...);
  
  // Act - Perform action
  final result = user.email;
  
  // Assert - Verify result
  expect(result, equals('test@example.com'));
});
```

### 2. Test Naming Convention
Use descriptive names that explain what is being tested:
```dart
// Good ✓
test('login should succeed with valid credentials', () {});

// Bad ✗
test('login test', () {});
```

### 3. Use setUp and tearDown
```dart
void main() {
  group('Group Name', () {
    setUp(() {
      // Initialize before each test
    });
    
    tearDown(() {
      // Clean up after each test
    });
    
    test('test name', () {});
  });
}
```

### 4. Test Edge Cases
```dart
test('should handle empty strings', () {
  final user = UserModel(name: '', email: '', avatar: '');
  expect(user.name, isEmpty);
});

test('should handle null values', () {
  // Test null handling
});

test('should handle large datasets', () {
  // Test performance with large data
});
```

### 5. Mock External Dependencies
```dart
@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  
  setUp(() {
    mockDio = MockDio();
  });
  
  test('should call API with correct parameters', () {
    // Setup mock
    when(mockDio.post(...)).thenAnswer((_) async => Response(...));
    
    // Test with mock
  });
}
```

---

## Widget Testing Tips

### Finding Widgets
```dart
// Find by type
find.byType(TextField)

// Find by text
find.text('Hello')

// Find by icon
find.byIcon(Icons.email)

// Find by key
find.byKey(Key('myButton'))

// Find by predicate
find.byWidgetPredicate((widget) => widget is TextField)
```

### User Interactions
```dart
// Tap widget
await tester.tap(find.byType(ElevatedButton));

// Enter text
await tester.enterText(find.byType(TextField), 'text');

// Scroll
await tester.scroll(find.byType(ListView), Offset(0, -300));

// Pump widget
await tester.pump(); // Rebuild once
await tester.pumpAndSettle(); // Keep rebuilding until stable
```

### Waiting for Async Operations
```dart
// Wait for one frame
await tester.pump();

// Wait for all animations to complete
await tester.pumpAndSettle();

// Wait for specific duration
await tester.pump(Duration(seconds: 2));
```

---

## Test Coverage

### Generate Coverage Report
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/
```

### View Coverage
```bash
# On macOS
open coverage/index.html

# On Windows
start coverage/index.html

# On Linux
xdg-open coverage/index.html
```

### Coverage Goals
- Aim for >80% overall coverage
- 100% coverage for critical business logic
- Focus on high-risk areas first

---

## Continuous Integration

### GitHub Actions Example
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v1
      - run: flutter pub get
      - run: flutter test
      - run: flutter test --coverage
```

---

## Common Issues & Solutions

### Issue: "State not initialized"
**Solution**: Use `pumpWidget()` before interacting with the widget
```dart
await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
await tester.tap(find.byType(ElevatedButton));
```

### Issue: "Find no widgets"
**Solution**: Use `pumpAndSettle()` to wait for animations
```dart
await tester.pumpAndSettle();
expect(find.text('Expected Text'), findsOneWidget);
```

### Issue: "Timeout waiting for animation"
**Solution**: Disable animations in tests
```dart
testWidgets('test name', (tester) async {
  addTearDown(tester.binding.window.physicalSizeTestValue =
      const Size(800, 600));
});
```

### Issue: "setState called during build"
**Solution**: Ensure proper async handling
```dart
await tester.pump(); // Wait for previous operations
await tester.tap(find.byType(Button));
await tester.pump(); // Let state updates complete
```

---

## Mocking Best Practices

### Mock API Responses
```dart
when(mockDio.post(
  any,
  data: anyNamed('data'),
)).thenAnswer((_) async => Response(
  data: {'token': 'test-token'},
  statusCode: 200,
  requestOptions: RequestOptions(path: ''),
));
```

### Mock SharedPreferences
```dart
SharedPreferences.setMockInitialValues({
  'token': 'test-token',
  'role': 'student',
});
```

---

## Writing New Tests

### Checklist
- [ ] Tests follow Arrange-Act-Assert pattern
- [ ] Test names are descriptive
- [ ] Tests are independent and can run in any order
- [ ] Edge cases are covered
- [ ] External dependencies are mocked
- [ ] Tests have appropriate assertions
- [ ] No hardcoded wait times (use pumpAndSettle)

### Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Feature Name Tests', () {
    setUp(() {
      // Initialize
    });

    test('should do something', () {
      // Arrange
      
      // Act
      
      // Assert
    });

    testWidgets('widget should display correctly', (tester) async {
      // Arrange
      
      // Act
      
      // Assert
    });
  });
}
```

---

## Performance Testing

### Testing Build Performance
```bash
flutter test test/screens/home_screen_test.dart --verbose
```

### Memory Profiling
```bash
flutter run --profile
# Use DevTools to check memory usage
```

---

## Debugging Tests

### Run Single Test
```bash
flutter test test/models/user_model_test.dart -v
```

### Print Debug Info
```dart
test('test name', () {
  debugPrint('Debug info: $variable');
  expect(...);
});
```

### Use Debugger
```bash
flutter test --start-paused
# Attach debugger and step through
```

---

## Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Integration Testing](https://flutter.dev/docs/testing/integration-tests)
- [Testing Best Practices](https://flutter.dev/docs/testing/best-practices)

---

## Questions & Support

For testing-related questions:
1. Check the Flutter testing documentation
2. Review existing test examples in the project
3. Ask the development team

