import 'package:flutter_test/flutter_test.dart';
import 'package:byte_quest/main.dart';

void main() {
  testWidgets('ByteQuest app launch test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ByteQuestApp());

    // Verify that ByteQuest title appears on splash screen.
    expect(find.text('ByteQuest'), findsOneWidget);
  });
}
