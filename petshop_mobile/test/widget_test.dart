import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_mobile/main.dart';

void main() {
  testWidgets('PetShopApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PetShopApp());
    expect(find.byType(PetShopApp), findsOneWidget);
  });
}
