import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/order.dart';
import 'package:nick/data/repo/order_repository.dart';
import 'package:nick/ui/cart/price_info.dart';
import 'package:nick/ui/payment_webview.dart';
import 'package:nick/ui/receipt/payment_receipt.dart';
import 'package:nick/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int totalPrice;
  final int shippingCost;

  const ShippingScreen({
    super.key,
    required this.payablePrice,
    required this.totalPrice,
    required this.shippingCost,
  });

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  StreamSubscription? subscription;
  final TextEditingController _firstNameController = TextEditingController(
    text: 'saeed',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: 'saeedPour',
  );
  final TextEditingController _mobileController = TextEditingController(
    text: '12345678910',
  );
  final TextEditingController _postalCodeController = TextEditingController(
    text: '1234567895',
  );
  final TextEditingController _addressController = TextEditingController(
    text: 'asasdasdasdzxczxczxgasewrwerwerwerwerwer',
  );

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 1, title: Text('تحویل گیرنده')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: BlocProvider<ShippingBloc>(
          create: (context) {
            final bloc = ShippingBloc(orderRepository: orderRepository);
            subscription = bloc.stream.listen((state) {
              if (state is ShippingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)),
                );
              } else if (state is ShippingSuccess) {
                if (state.result.bankGatewayUrl.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentGateWayScreen(
                        bankGatewayUrl: state.result.bankGatewayUrl,
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentReceiptScreen(orderId: state.result.orderId),
                    ),
                  );
                }
              }
            });
            return bloc;
          },
          child: SingleChildScrollView(
            physics: defultScrollPhysics,
            child: Column(
              children: [
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _firstNameController,
                  decoration: InputDecoration(label: Text('نام')),
                ),
                SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _lastNameController,
                  decoration: InputDecoration(label: Text('نام خانوادگی')),
                ),
                SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _mobileController,
                  decoration: InputDecoration(label: Text('شماره تماس')),
                ),
                SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _postalCodeController,
                  decoration: InputDecoration(label: Text('کد پستی')),
                ),
                SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _addressController,
                  decoration: InputDecoration(label: Text('آدرس')),
                ),
                PriceInfo(
                  payablePrice: widget.payablePrice,
                  totalPrice: widget.totalPrice,
                  shippingCost: widget.shippingCost,
                ),
                BlocBuilder<ShippingBloc, ShippingState>(
                  builder: (context, state) {
                    return state is ShippingLoading
                        ? CupertinoActivityIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreatOrder(
                                      params: CreateOrderParams(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        postalCode: _postalCodeController.text,
                                        mobile: _mobileController.text,
                                        address: _addressController.text,
                                        paymentMethod:
                                            PaymentMethod.cashOnDelivery,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('پرداخت در محل'),
                              ),
                              SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<ShippingBloc>(context).add(
                                    ShippingCreatOrder(
                                      params: CreateOrderParams(
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        postalCode: _postalCodeController.text,
                                        mobile: _mobileController.text,
                                        address: _addressController.text,
                                        paymentMethod: PaymentMethod.online,
                                      ),
                                    ),
                                  );
                                },
                                child: Text('پرداخت اینترنتی'),
                              ),
                            ],
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
