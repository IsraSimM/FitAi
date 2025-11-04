import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:freet/app/app.dart';

void main() {
  testWidgets('FreeTApp renders onboarding by default', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FreeTApp()));

    expect(find.text('Configura tu experiencia'), findsOneWidget);
  });
}
