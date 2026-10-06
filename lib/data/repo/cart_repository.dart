import 'package:flutter/cupertino.dart';
import 'package:nick/common/http_client.dart';
import 'package:nick/data/add_to_cart_response.dart';
import 'package:nick/data/cart_response.dart';
import 'package:nick/data/source/cart_data_source.dart';

final cartRepository = CartRepository(
  dataSource: CartRemoteDataSource(httpClient: httpClient),
);

abstract class ICartRepository extends ICartDataSource {}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static final ValueNotifier<int> countValueNotifier = ValueNotifier(0);
  CartRepository({required this.dataSource});

  @override
  Future<AddToCartResponse> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartResponse> changeCount(int count, int cartItemId) {
    return dataSource.changeCount(count, cartItemId);
  }

  @override
  Future<int> count() async{
    final count  = await dataSource.count();
    countValueNotifier.value = count;
    return count;
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
