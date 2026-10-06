import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/product.dart';
import 'package:nick/data/repo/banner_repository.dart';
import 'package:nick/data/repo/product_repository.dart';
import 'package:nick/theme.dart';
import 'package:nick/ui/home/bloc/home_bloc.dart';
import 'package:nick/ui/list/product_list.dart';
import 'package:nick/ui/product/product.dart';
import 'package:nick/ui/widgets/error.dart';
import 'package:nick/ui/widgets/slider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return BlocProvider<HomeBloc>(
      create: (context) {
        final homeBloc = HomeBloc(
          bannerRepository: bannerRepository,
          productRepository: productRepository,
        );
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                  physics: defultScrollPhysics,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/img/nike_logo.png',
                                height: 24,
                              ),
                            ),
                            Container(
                              height: 46,
                              margin: EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: TextField(
                                onSubmitted: (value) {
                                  _search(context);
                                },
                                controller: _searchController,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  color: LightThemeColors.primaryTextColor,
                                ),
                                decoration: InputDecoration(
                                  label: Text('جستجو'),
                                  prefixIcon: IconButton(
                                    onPressed: () {
                                      _search(context);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.search,
                                      color: themeData.colorScheme.outline,
                                      size: 20,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: BorderSide(
                                      color: themeData.colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: BorderSide(
                                      color: themeData.colorScheme.primary,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: themeData.colorScheme.outline,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                              ),
                            ),
                          ],
                        );
                      case 2:
                        return BannerSlider(banners: state.banners);
                      case 3:
                        return HorizontalProductList(
                          themeData: themeData,
                          products: state.latestProducts,
                          title: 'جدید ترین',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductListScreen(sort: ProductSort.latest),
                              ),
                            );
                          },
                        );
                      case 4:
                        return HorizontalProductList(
                          themeData: themeData,
                          products: state.papularProducts,
                          title: 'محبوب ترین ها',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductListScreen(
                                  sort: ProductSort.popular,
                                ),
                              ),
                            );
                          },
                        );
                      default:
                        return Container();
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return AppErrorWidget(
                  exception: state.exception,
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  },
                );
              } else {
                throw Exception('State is not valid or supported');
              }
            },
          ),
        ),
      ),
    );
  }

  void _search(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProductListScreen.search(searchTerm: _searchController.text),
      ),
    );
  }
}

class HorizontalProductList extends StatelessWidget {
  final List<ProductEntity> products;
  final String title;
  final GestureTapCallback onTap;

  const HorizontalProductList({
    super.key,
    required this.themeData,
    required this.products,
    required this.title,
    required this.onTap,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: themeData.textTheme.titleMedium),
              TextButton(onPressed: onTap, child: Text('مشاهده همه')),
            ],
          ),
        ),
        SizedBox(
          height: 290,
          child: ListView.builder(
            physics: defultScrollPhysics,
            padding: const EdgeInsets.only(left: 8, right: 8),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(
                product: product,
                borderRadius: BorderRadius.circular(8),
              );
            },
          ),
        ),
      ],
    );
  }
}
