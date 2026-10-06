import 'package:dio/dio.dart';
import 'package:nick/data/common/response_validator.dart';
import 'package:nick/data/order.dart';
import 'package:nick/data/payment_receipt_data.dart';
import 'package:nick/data/repo/order_repository.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);

  Future<PaymentReceiptData> getPaymentReceipt(int orderId);

  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource
    with HttpResponseValidator
    implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource({required this.httpClient});

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post(
      'order/submit',
      data: {
        'first_name': params.firstName,
        'last_name': params.lastName,
        'postal_code': params.postalCode,
        'mobile': params.mobile,
        'address': params.address,
        'payment_method': params.paymentMethod == PaymentMethod.online
            ? 'online'
            : 'cash_on_delivery',
      },
    );
    validateResponse(response);
    return CreateOrderResult.fromJson(response.data);
  }

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) async {
    final response = await httpClient.get('order/checkout?order_id=${orderId}');
    validateResponse(response);
    return PaymentReceiptData.fromJson(response.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final response = await httpClient.get('order/list');
    validateResponse(response);
    return (response.data as List)
        .map((item) => OrderEntity.fromJson(item))
        .toList();
  }
}
