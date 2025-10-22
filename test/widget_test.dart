import "package:flutter_test/flutter_test.dart";
import "package:fit_ai_app/app/app.dart";

void main() {
  testWidgets("FitAiApp arranca y muestra Dashboard", (tester) async {
    // Render de la app
    await tester.pumpWidget(const FitAiApp());

    // Verifica que aparece el texto de la pantalla inicial (Dashboard)
    expect(find.text("Dashboard (Fase 2) lista para escalar"), findsOneWidget);
  });
}
