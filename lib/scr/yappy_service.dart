import 'dart:convert';
import 'package:http/http.dart' as http;

class YappyServices {
  final String apiUrl;

  YappyServices({required this.apiUrl});

  Future<Map<String, dynamic>> createPayment({
    required String aliasYappy,
    required double amount,
    required String reference,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Accept': 'application/json'},
        body: {
          'amount': amount.toString(),
          'reference': reference,
          'description': description,
          'alias_yappy': aliasYappy,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return {
          'error': false,
          'payment_url': data['data']['payment_url'],
          'token': data['data']['token'],
        };
      } else {
        return {
          'error': true,
          'message': data['message'] ?? 'Error desconocido',
          'data': data,
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': e.toString(),
        'exception': true,
      };
    }
  }
}
