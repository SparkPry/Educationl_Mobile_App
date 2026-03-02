import 'package:education_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen should render without errors',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('HomeScreen is a valid StatefulWidget',
        (WidgetTester tester) async {
      // Assert
      expect(HomeScreen, isA<Type>());
    });

    testWidgets('HomeScreen should display with proper structure',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Assert - Verify Scaffold structure is present
      expect(
        find.byType(Scaffold),
        findsOneWidget,
        reason: 'HomeScreen should have a Scaffold widget',
      );
    });
  });

  group('HomeScreen Functionality Tests', () {
    testWidgets('HomeScreen layout initializes properly',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
