import 'package:nick/data/product.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGatewayUrl;

  CreateOrderResult.fromJson(Map<String, dynamic> json)
    : orderId = json['order_id'],
      bankGatewayUrl = json['bank_gateway_url'];
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String postalCode;
  final String mobile;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams({
    required this.firstName,
    required this.lastName,
    required this.postalCode,
    required this.mobile,
    required this.address,
    required this.paymentMethod,
  });
}

enum PaymentMethod { online, cashOnDelivery }

class OrderEntity {
  final int id;
  final int payable;
  final List<ProductEntity> products;

  OrderEntity(this.id, this.payable, this.products);

  OrderEntity.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      payable = json['payable'],
      products = (json['order_items'] as List)
          .map((item) => ProductEntity.fromJson(item['product']))
          .toList();
}
