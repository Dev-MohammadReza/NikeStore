



import 'package:nick/common/http_client.dart';
import 'package:nick/data/order.dart';
import 'package:nick/data/payment_receipt_data.dart';
import 'package:nick/data/source/order_data_source.dart';

final orderRepository = OrderRepository(dataSource: OrderRemoteDataSource(httpClient: httpClient));

abstract class IOrderRepository extends IOrderDataSource{}


class OrderRepository implements IOrderRepository{
  final IOrderDataSource dataSource;

  OrderRepository({required this.dataSource});

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) => dataSource.create(params);

  @override
  Future<PaymentReceiptData> getPaymentReceipt(int orderId) => dataSource.getPaymentReceipt(orderId);

  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}