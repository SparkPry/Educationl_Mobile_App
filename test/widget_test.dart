import 'package:education_app/main.dart';
import 'package:education_app/screens/onboarding_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen shows app name and navigates to onboarding', (
    WidgetTester tester,
  ) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 2. Verify that our Splash Screen shows the logo image
    expect(find.byType(Image), findsOneWidget);

    // 3. Pump the widget with the splash duration to simulate the timer.
    await tester.pump(const Duration(seconds: 3));

    // 4. Allow any pending animations / navigation to settle.
    await tester.pumpAndSettle();

    // 5. Verify that the OnboardingScreen is now visible.
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
