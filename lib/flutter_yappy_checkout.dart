library flutter_yappy_checkout;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YappyCheckout extends StatefulWidget {
  final Function? onSuccess, onCancel, onError;
  final String apiUrl;
  final String aliasYappy;
  final double amount;
  final String reference;
  final String description;

  const YappyCheckout({
    Key? key,
    required this.apiUrl,
    required this.aliasYappy,
    required this.amount,
    required this.reference,
    required this.description,
    this.onSuccess,
    this.onCancel,
    this.onError,
  }) : super(key: key);

  @override
  State<YappyCheckout> createState() => _YappyCheckoutState();
}

class _YappyCheckoutState extends State<YappyCheckout> {
  String? paymentUrl;
  double progress = 0;
  late InAppWebViewController webViewController;

  @override
  void initState() {
    super.initState();
    _createYappyOrder();
  }

  Future<void> _createYappyOrder() async {
    try {
      final response = await http.post(
        Uri.parse(widget.apiUrl),
        headers: {'Accept': 'application/json'},
        body: {
          'amount': widget.amount.toString(),
          'reference': widget.reference,
          'description': widget.description,
          'alias_yappy': widget.aliasYappy,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        setState(() {
          paymentUrl = data['data']['payment_url'];
        });
      } else {
        widget.onError?.call(data);
        Navigator.of(context).pop();
      }
    } catch (e) {
      widget.onError?.call(e);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pago con Yappy")),
      body: paymentUrl == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                InAppWebView(
                  initialUrlRequest:
                      URLRequest(url: WebUri.uri(Uri.parse(paymentUrl!))),
                  initialSettings: InAppWebViewSettings(textZoom: 120),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (_, url) {
                    if (url != null && url.toString().contains("waiting")) {
                      widget.onSuccess?.call();
                      Navigator.of(context).pop();
                    }
                  },
                  onProgressChanged: (controller, progressValue) {
                    setState(() {
                      progress = progressValue / 100;
                    });
                  },
                ),
                if (progress < 1)
                  SizedBox(
                    height: 3,
                    child: LinearProgressIndicator(value: progress),
                  ),
              ],
            ),
    );
  }
}
