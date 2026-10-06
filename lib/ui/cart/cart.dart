import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/ui/auth/auth.dart';
import 'package:nick/ui/cart/bloc/cart_bloc.dart';
import 'package:nick/ui/cart/cart_item.dart';
import 'package:nick/ui/cart/price_info.dart';
import 'package:nick/ui/shipping/shipping.dart';
import 'package:nick/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
  }

  void authChangeNotifierListener() {
    context.read<CartBloc>().add(
      CartAuthInfoChanged(authInfo: AuthRepository.authChangeNotifier.value),
    );
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier.removeListener(
      authChangeNotifierListener,
    );

    _refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.surfaceVariant,

      appBar: AppBar(centerTitle: true, title: const Text('سبد خرید')),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartSuccess) {
            return const SizedBox.shrink();
          }

          return Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 48, right: 48),
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShippingScreen(
                      payablePrice: state.cartResponse.payablePrice,
                      totalPrice: state.cartResponse.totalPrice,
                      shippingCost: state.cartResponse.shippingCost,
                    ),
                  ),
                );
              },
              label: const Text('پرداخت'),
            ),
          );
        },
      ),

      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (_refreshController.isRefresh) {
            if (state is CartSuccess ||
                state is CartEmpty ||
                state is CartError) {
              _refreshController.refreshCompleted();
            }
          }
        },

        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartError) {
              return Center(child: Text(state.exception.message));
            }

            if (state is CartAuthRequired) {
              return EmptyView(
                callToAction: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const AuthScreen(),
                      ),
                    );
                  },
                  child: const Text('ورود به حساب کاربری'),
                ),
                massage:
                    'برای دیدن سبد خرید باید به حساب کاربری خود وارد بشوید',
                image: SvgPicture.asset(
                  'assets/img/auth_required.svg',
                  width: 120,
                ),
              );
            }

            if (state is CartEmpty) {
              return EmptyView(
                massage: 'تاکنون محصولی به سبد خرید اضافه نکردید',
                image: SvgPicture.asset(
                  'assets/img/empty_cart.svg',
                  width: 150,
                ),
              );
            }

            if (state is CartSuccess) {
              return SmartRefresher(
                controller: _refreshController,

                header: ClassicHeader(
                  completeText: 'بروزرسانی با موفقیت انجام شد',

                  completeIcon: const Icon(
                    CupertinoIcons.checkmark_alt_circle,
                    color: Colors.grey,
                    size: 20,
                  ),

                  idleText: 'برای بروزرسانی پایین بکشید',

                  refreshingText: 'درحال بروزرسانی',

                  refreshingIcon: const CupertinoActivityIndicator(),

                  releaseText: 'رها کنید',

                  failedText: 'ارور نامشخص',

                  spacing: 2,
                ),

                onRefresh: () {
                  context.read<CartBloc>().add(
                    CartStarted(
                      authInfo: AuthRepository.authChangeNotifier.value,
                      isRefresh: true,
                    ),
                  );
                },

                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 60),

                  itemCount: state.cartResponse.cartItems.length + 1,

                  itemBuilder: (context, index) {
                    if (index < state.cartResponse.cartItems.length) {
                      final data = state.cartResponse.cartItems[index];

                      return CartListItem(
                        data: data,
                        themeData: themeData,

                        clickOnInCrease: () {
                          context.read<CartBloc>().add(
                            CartInCreaseBottonClicked(cartItemId: data.id),
                          );
                        },

                        clickOnDecrease: () {
                          if (data.count > 1) {
                            context.read<CartBloc>().add(
                              CartDeCreaseBottonClicked(cartItemId: data.id),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تعداد محصول نمی‌تواند کمتر از ۱ باشد',
                                ),
                              ),
                            );
                          }
                        },

                        clickedOnDelete: () {
                          context.read<CartBloc>().add(
                            CartDeleteBottonClicked(cartItemId: data.id),
                          );
                        },
                      );
                    }

                    return PriceInfo(
                      payablePrice: state.cartResponse.payablePrice,
                      totalPrice: state.cartResponse.totalPrice,
                      shippingCost: state.cartResponse.shippingCost,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
