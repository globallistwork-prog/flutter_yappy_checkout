import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yappy_checkout/flutter_yappy_checkout.dart';

void main() {
  testWidgets('YappyCheckout widget renders loading state',
      (WidgetTester tester) async {
    // Crear un widget YappyCheckout con datos de prueba
    await tester.pumpWidget(
      MaterialApp(
        home: YappyCheckout(
          apiUrl: 'https://tuapi.com/api/payments/yappy/initiate',
          aliasYappy: '12345678',
          amount: 5.0,
          reference: 'TEST-REF-001',
          description: 'Pago de prueba',
          onSuccess: () {},
          onCancel: () {},
          onError: (e) {
            debugPrint("Error: $e");
          },
        ),
      ),
    );

    // Verifica que se muestra un CircularProgressIndicator inicialmente
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
