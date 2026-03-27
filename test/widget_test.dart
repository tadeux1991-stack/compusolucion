import 'package:flutter_test/flutter_test.dart';
import 'package:compusolucion_web/main.dart';

void main() {
  testWidgets('Carga de CompusolucionApp', (WidgetTester tester) async {
    await tester.pumpWidget(const CompusolucionApp());
    expect(find.text('COMPUSOLUCIÓN'), findsWidgets);
  });
}
