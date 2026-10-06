import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/repo/order_repository.dart';
import 'package:nick/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;

  const PaymentReceiptScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('رسید پرداخت')),
      body: BlocProvider<PaymentReceiptBloc>(
        create: (context) =>
        PaymentReceiptBloc(orderRepository: orderRepository)
          ..add(PaymentReceiptStarted(orderId: orderId)),
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if(state is PaymentReceiptSuccess) {
              return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: themeData.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Text(
                        state.data.purchaseSuccess?'پرداخت با موفقیت انجام شد':'پرداخت ناموفق',
                       style: themeData.textTheme.titleMedium!.copyWith(
                          color: themeData.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'وضعیت سفارش',
                            style: themeData.textTheme.titleMedium,
                          ),
                          Text(state.data.paymentStatus, style: themeData.textTheme
                              .titleSmall),
                        ],
                      ),
                      Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('مبلغ', style: themeData.textTheme.titleMedium),
                          Text(
                            state.data.payablePrice.withPriceLabel,
                            style: themeData.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((root) => root.isFirst);
                  },
                  child: Text('بازگشت به صفحه اصلی'),
                ),
              ],
            );
            }else if(state is PaymentReceiptLoading){
              return Center(child: CupertinoActivityIndicator());
            }else if(state is PaymentReceiptError){
              return Center(child: Text(state.exception.message));
            }else{
              throw Exception('State is not supported');
            }
          },
        ),
      ),
    );
  }
}
