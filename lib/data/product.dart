import 'package:hive_flutter/adapters.dart';

part 'product.g.dart';
class ProductSort {
  static const int latest = 0;
  static const int popular = 1;
  static const int priceHighToLow = 2;
  static const int priceLowToHigh = 3;

  static const List<String> names = [
    'جدیدترین',
    'پربازدید ترین',
    'قیمت از بالا به پایین',
    'قیمت از پایین به بالا',
  ];
}

@HiveType(typeId: 0)
class ProductEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int discount;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final int previousPrice;

  ProductEntity(this.id, this.title, this.price, this.discount, this.imageUrl,
      this.previousPrice);


  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['previous_price'] == null
            ? json['price'] - json['discount']
            : json['price'],
        previousPrice = json['previous_price'] ?? json['price'],
        discount = json['discount'];
}
