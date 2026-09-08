import 'package:flutter_test/flutter_test.dart';
import 'package:inert_button_app/main.dart';

void main() {
  testWidgets('shows an enabled inert button', (tester) async {
    await tester.pumpWidget(const InertButtonApp());

    expect(find.text('Press me'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
