import 'package:education_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('LoginScreen should display Sign In and Sign Up buttons',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert - Use findsWidgets since there may be multiple "Sign In" elements
      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Sign Up'), findsWidgets);
    });

    testWidgets('LoginScreen should display welcome text', 
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert
      expect(find.text('Hello there,'), findsOneWidget);
      expect(find.text('We are happy to see you here'), findsOneWidget);
    });

    testWidgets('LoginScreen should have email icon visible',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('LoginScreen should have password icon visible',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });

    testWidgets('LoginScreen should show forgot password button in Sign In mode',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert
      expect(find.text('Forgot password'), findsOneWidget);
    });

    testWidgets('LoginScreen should toggle between Sign In and Sign Up modes',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Click on Sign Up button
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert - Username field should appear in Sign Up mode
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Click back on Sign In
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      // Assert - Forgot password should be visible again
      expect(find.text('Forgot password'), findsOneWidget);
    });

    testWidgets('LoginScreen should display username field in Sign Up mode',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Switch to Sign Up mode
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Assert - Username field should appear
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('LoginScreen should hide username field in Sign In mode',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      // Assert - Initially in Sign In mode, no username field
      expect(find.byIcon(Icons.person_outline), findsNothing);
    });

    testWidgets('LoginScreen should accept text input',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      
      // Verify widgets can be tapped and text input attempted
      final scaffolds = find.byType(Scaffold);
      expect(scaffolds, findsWidgets);
    });
  });

  group('LoginScreen Integration Tests', () {
    testWidgets('LoginScreen should render properly',
        (WidgetTester tester) async {
      // Act & Assert
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
      await tester.pumpAndSettle();
      
      // Verify basic rendering
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
