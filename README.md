# flutter_yappy_checkout

Este plugin permite a las apps Flutter integrarse fácilmente con la pasarela de pagos Yappy (Banco General).

## Cómo usar

```dart
YappyCheckout(
  amount: 12.5,
  reference: 'BOOKING-1234567890',
  description: 'Pago de reserva',
  apiUrl: 'https://tudominio.com/api/yappy/create',
  aliasYappy: '67845176',
);
```

Incluye una WebView integrada para completar el pago.
