import 'package:flutter_test/flutter_test.dart';
import 'package:inert_button_app/main.dart';

void main() {
  testWidgets('shows and activates the singular button', (tester) async {
    await tester.pumpWidget(const BubbleButtonApp());
    expect(find.text('press me'), findsOneWidget);
    await tester.tap(find.text('press me'));
    await tester.pump();
    expect(find.textContaining('this webpage is gonna give you a virus'),
        findsOneWidget);
    expect(find.text('5'), findsOneWidget);
  });
}
