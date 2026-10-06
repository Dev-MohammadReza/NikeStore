import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/favorite_manager.dart';
import 'package:nick/data/product.dart';
import 'package:nick/ui/product/detail.dart';
import 'package:nick/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  final BorderRadius borderRadius;

  const ProductItem({
    super.key,
    required this.product,
    required this.borderRadius,
  });

  final ProductEntity product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: widget.borderRadius,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailProductScreen(product: widget.product),
          ),
        );
      },
      child: SizedBox(
        width: 176,
        child: Padding(
          padding: const EdgeInsets.only(right: 4, left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.93,
                    child: ImageLoadingService(
                      imageUrl: widget.product.imageUrl,
                      borderRadius: widget.borderRadius,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: ValueListenableBuilder<Box<ProductEntity>>(
                      valueListenable: favoriteManager.listenable,
                      builder:(context, box, child) {
                        return InkWell(
                        onTap: () {
                          favoriteManager.addOrDelete(widget.product);
                          setState(() {});
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            favoriteManager.isFavorite(widget.product)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                            size: 20,
                          ),
                        ),
                      );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, bottom: 4),
                child: Text(
                  widget.product.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.apply(fontSizeFactor: 0.8),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Text(
                  widget.product.previousPrice.withPriceLabel,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Text(widget.product.price.withPriceLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
