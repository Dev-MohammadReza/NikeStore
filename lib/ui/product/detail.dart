import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/add_to_cart_response.dart';
import 'package:nick/data/favorite_manager.dart';
import 'package:nick/data/product.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/ui/cart/bloc/cart_bloc.dart';
import 'package:nick/ui/product/bloc/product_bloc.dart';
import 'package:nick/ui/product/comment/comment_list.dart';
import 'package:nick/ui/product/comment/insert/insert_comment_dialog.dart';
import 'package:nick/ui/widgets/image.dart';

class DetailProductScreen extends StatefulWidget {
  final ProductEntity product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository: cartRepository);
          bloc.stream.forEach((state){
            if (state is ProductSuccess){
               context.read<CartBloc>().add(CartRefresh());
              _scaffoldKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text('محصول با موفقیت به سید خرید شما اضافه شد'),
                ),
              );
            } else if (state is ProductError) {
              _scaffoldKey.currentState?.showSnackBar(
                SnackBar(content: Text(state.exception.message)),
              );
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state){
                  return FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context).add(
                        ProductClickOnAddBotton(productId: widget.product.id),
                      );
                    },
                    label: state is ProductLoading
                        ? CupertinoActivityIndicator(
                            color: themeData.colorScheme.onSecondary,
                          )
                        : Text('افزودن به سبد خرید'),
                  );
                },
              ),
            ),
            body: CustomScrollView(
              physics: defultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.6,
                  flexibleSpace: ImageLoadingService(
                    imageUrl: widget.product.imageUrl,
                  ),
                  actions: [
                    ValueListenableBuilder<Box<ProductEntity>>(
                      valueListenable: favoriteManager.listenable,
                      builder: (context, box, child) {
                        return IconButton(
                          onPressed: () {
                            favoriteManager.addOrDelete(widget.product);
                          },
                          icon: Icon(
                            favoriteManager.isFavorite(widget.product)
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                maxLines: 1,
                                widget.product.title,
                                style: themeData.textTheme.headlineSmall!
                                    .copyWith(overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: themeData.textTheme.bodySmall!.apply(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(widget.product.price.withPriceLabel),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا. هیچ فشار مخربی رو نمیذارد به پا و زانوان شما انتقال داده شود',
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نظرات کاربران',
                              style: themeData.textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  useRootNavigator: true,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                      ),
                                      child: SingleChildScrollView(
                                        child: InsertCommentDialog(
                                          productId: widget.product.id,
                                          scaffoldMessenger:
                                              _scaffoldKey.currentState,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text('ثبت نظر'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
                SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
