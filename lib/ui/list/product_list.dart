import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/product.dart';
import 'package:nick/data/repo/product_repository.dart';
import 'package:nick/ui/list/bloc/product_list_bloc.dart';
import 'package:nick/ui/product/product.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;
  final String searchTerm;

  const ProductListScreen({
    super.key,
    this.searchTerm = '',
    required this.sort,
  });

  const ProductListScreen.search({
    super.key,
    required this.searchTerm,
    this.sort = ProductSort.popular,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType { grid, list }

class _ProductListScreenState extends State<ProductListScreen> {
  ViewType viewType = ViewType.grid;
  ProductListBloc? productListBloc;

  @override
  void dispose() {
    productListBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: widget.searchTerm.isEmpty?false:true,
        title: Text(
          widget.searchTerm.isEmpty
              ? 'کفش های ورزشی'
              : 'نتایج سرچ ${widget.searchTerm}',
        ),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          productListBloc = ProductListBloc(productRepository)
            ..add(
              ProductListStarted(
                sort: widget.sort,
                searchTerm: widget.searchTerm,
              ),
            );
          return productListBloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final List<ProductEntity> products = state.products;
              return Column(
                children: [
                  if (widget.searchTerm.isEmpty)
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.surface,
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: themeData.colorScheme.outline,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              child: Text(
                                                'انتخاب نوع مرتب سازی',
                                                style: themeData
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: state.names.length,
                                                itemBuilder: (context, index) {
                                                  final selectedSortIndex =
                                                      state.sort;
                                                  return InkWell(
                                                    onTap: () {
                                                      productListBloc!.add(
                                                        ProductListStarted(
                                                          sort: index,
                                                          searchTerm:
                                                              widget.searchTerm,
                                                        ),
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            state.names[index],
                                                            style: themeData
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          if (selectedSortIndex ==
                                                              index)
                                                            Icon(
                                                              CupertinoIcons
                                                                  .checkmark_alt_circle,
                                                              color: themeData
                                                                  .colorScheme
                                                                  .primary,
                                                              size: 22,
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.sort_down),
                                    SizedBox(width: 4),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('مرتب سازی'),
                                        Text(
                                          state.names[state.sort],
                                          style: themeData.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            color: themeData.colorScheme.outline,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  viewType = viewType == ViewType.grid
                                      ? ViewType.list
                                      : ViewType.grid;
                                });
                              },
                              icon: Icon(
                                viewType == ViewType.grid
                                    ? CupertinoIcons.square_grid_2x2
                                    : CupertinoIcons
                                          .list_bullet_below_rectangle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      physics: defultScrollPhysics,
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: viewType == ViewType.grid ? 2 : 1,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                          product: product,
                          borderRadius: BorderRadius.zero,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is ProductListLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is ProductListError) {
              return Center(child: Text(state.exception.message));
            } else if (state is ProductListEmpty) {
              return Center(child: Text(state.emptyMassage));
            } else {
              throw Exception('State is not valid');
            }
          },
        ),
      ),
    );
  }
}
