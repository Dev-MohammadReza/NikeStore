import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/favorite_manager.dart';
import 'package:nick/data/product.dart';
import 'package:nick/ui/product/detail.dart';
import 'package:nick/ui/widgets/empty_state.dart';
import 'package:nick/ui/widgets/image.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('لیست علاقه مندی ها'), centerTitle: true),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManager.listenable,
        builder: (context, box, child) {
          final products = box.values.toList();
          if(products.isNotEmpty) {
            return ListView.builder(
            physics: defultScrollPhysics,
            padding: EdgeInsets.only(top: 8, bottom: 100),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailProductScreen(product: product)));
                },
                onLongPress: (){
                  favoriteManager.delete(product);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 110,
                        width: 100,
                        child: ImageLoadingService(
                          imageUrl: product.imageUrl,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: themeData.textTheme.titleLarge!.apply(
                                  fontSizeFactor: 0.8,
                                ),
                              ),
                              SizedBox(height: 24),
                              Text(
                                product.previousPrice.withPriceLabel,
                                style: themeData.textTheme.bodySmall!.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(product.previousPrice.withPriceLabel),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          }else{
            return EmptyView(massage: 'لیست علاقه مندی ها خالی است', image: SvgPicture.asset('assets/img/no_data.svg',width: 110,));
          }
        },
      ),
    );
  }
}
