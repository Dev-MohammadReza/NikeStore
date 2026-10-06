import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/cart.dart';
import 'package:nick/ui/widgets/image.dart';

class CartListItem extends StatelessWidget {
  const CartListItem({
    super.key,
    required this.data,
    required this.themeData,
    required this.clickedOnDelete,
    required this.clickOnInCrease,
    required this.clickOnDecrease,
  });

  final CartItemEntity data;
  final ThemeData themeData;
  final GestureTapCallback clickedOnDelete;
  final GestureTapCallback clickOnInCrease;
  final GestureTapCallback clickOnDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data.product.title,
                    style: themeData.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('تعداد', style: themeData.textTheme.titleSmall),
                    Row(
                      children: [
                        IconButton(
                          onPressed: clickOnInCrease,
                          icon: Icon(CupertinoIcons.plus_rectangle),
                        ),
                        data.isChangeLoading?CupertinoActivityIndicator():Text(
                          data.count.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: clickOnDecrease,
                          icon: Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      data.product.previousPrice.withPriceLabel,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough),
                    ),
                    Text(data.product.price.withPriceLabel),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.4)),
          data.isLoading
              ? Center(child: CupertinoActivityIndicator())
              : TextButton(
                  onPressed: clickedOnDelete,
                  child: Text('حذف از سبد خرید'),
                ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
