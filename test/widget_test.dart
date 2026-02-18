import 'package:education_app/main.dart';
import 'package:education_app/screens/onboarding_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash screen shows app name and navigates to onboarding', (
    WidgetTester tester,
  ) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // 2. Verify that our Splash Screen shows the text "AngkorEdu"
    expect(find.text('AngkorEdu'), findsOneWidget);

    // 3. Pump the widget with a duration to simulate the timer.
    await tester.pump(const Duration(seconds: 2));

    // 4. Pump the widget again to trigger the navigation.
    await tester.pump();

    // 5. Verify that the OnboardingScreen is now visible.
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
