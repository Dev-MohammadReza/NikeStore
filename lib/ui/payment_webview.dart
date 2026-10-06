import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWayScreen extends StatefulWidget {
  const PaymentGateWayScreen({super.key, required this.bankGatewayUrl,});
  final String bankGatewayUrl;

  @override
  State<PaymentGateWayScreen> createState() => _PaymentGateWayScreenState();
}

class _PaymentGateWayScreenState extends State<PaymentGateWayScreen> {
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url){
        final uri = Uri.parse(url);
        if(uri.pathSegments.contains('checkout')&& uri.host == 'expertdevelopers.ir'){
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PaymentReceiptScreen(orderId: orderId)));
        };
      }),)..loadRequest(Uri.parse(widget.bankGatewayUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: webViewController);
  }
}
