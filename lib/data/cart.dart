import 'package:nick/data/product.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  int count;
  bool isLoading = false;
  bool isChangeLoading = false;
  CartItemEntity.fromJson(Map<String, dynamic> json)
    : product = ProductEntity.fromJson(json['product']),
      id = json['cart_item_id'],
      count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArray){
    final List<CartItemEntity> cartItems=[];
    jsonArray.forEach((jsonObject){
      cartItems.add(CartItemEntity.fromJson(jsonObject));
    });
    return cartItems;
  }
}
