import 'package:dio/dio.dart';
import 'package:nick/data/cart.dart';
import 'package:nick/data/add_to_cart_response.dart';
import 'package:nick/data/cart_response.dart';
import 'package:nick/data/common/response_validator.dart';

abstract class ICartDataSource {
  Future<AddToCartResponse> add(int productId);

  Future<CartResponse> getAll();

  Future<void> delete(int cartItemId);

  Future<int> count();

  Future<AddToCartResponse> changeCount(int count, int cartItemId);
}

class CartRemoteDataSource with HttpResponseValidator implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource({required this.httpClient});

  @override
  Future<AddToCartResponse> add(int productId) async {
    final response = await httpClient.post(
      'cart/add',
      data: {"product_id": productId},
    );
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int count, int cartItemId) async{
    final response = await httpClient.post('cart/changeCount',data: {
      "cart_item_id":cartItemId,
      "count":count,
    });
    validateResponse(response);
    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async{
   final response = await httpClient.get('cart/count');
   validateResponse(response);
   return response.data['count'];
  }

  @override
  Future<void> delete(int cartItemId) async{
    await httpClient.post('cart/remove',data: {
      'cart_item_id':cartItemId,
    });
  }

  @override
  Future<CartResponse> getAll() async{
   final response = await httpClient.get('cart/list');
   validateResponse(response);
   return CartResponse.fromJson(response.data);
  }
}
