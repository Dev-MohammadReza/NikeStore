import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nick/data/product.dart';

final favoriteManager =  FavoriteManager();

class FavoriteManager {
  static const boxName = 'favoriteBox';
  final _box = Hive.box<ProductEntity>(boxName);

  ValueListenable<Box<ProductEntity>> listenable = Hive.box<ProductEntity>(boxName).listenable();

  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(boxName);
  }

  void addOrDelete(ProductEntity product){
    if(isFavorite(product)){
      delete(product);
    }else{
      addFavorite(product);
    }
  }

  void addFavorite(ProductEntity product) {
    _box.put(product.id, product);
  }

  void delete(ProductEntity product) {
    _box.delete(product.id);
  }

  List<ProductEntity> get favorites => _box.values.toList();

  bool isFavorite(ProductEntity product) {
    return _box.containsKey(product.id);
  }
}
