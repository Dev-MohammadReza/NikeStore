import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/repo/order_repository.dart';
import 'package:nick/ui/order/bloc/order_history_bloc.dart';
import 'package:nick/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('سوابق سفارش'), centerTitle: true),
      body: BlocProvider<OrderHistoryBloc>(
        create: (context) =>
            OrderHistoryBloc(orderRepository: orderRepository)
              ..add(OrderHistoryStarted()),
        child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                physics: defultScrollPhysics,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        width: 1,
                        color: themeData.colorScheme.outline,
                      ),
                    ),
                    child: Column(

                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('شناسه سفارش'),
                              Text(order.id.toString()),
                            ],
                          ),
                        ),
                        Divider(height: 1),
                        Padding(
                          padding: EdgeInsets.only(right: 16, left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('مبلغ'),
                              Text(order.payable.withPriceLabel),
                            ],
                          ),
                        ),
                        Divider(height: 1,),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            physics: defultScrollPhysics,
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                            itemCount: order.products.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                            return Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(right: 4,left: 4),
                              child: ImageLoadingService(imageUrl: order.products[index].imageUrl,borderRadius: BorderRadius.circular(8),),
                            );
                          },),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryLoading ||
                state is OrderHistoryInitial) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is OrderHistoryError) {
              return Center(child: Text(state.exception.message));
            } else {
              throw Exception('State is not valid');
            }
          },
        ),
      ),
    );
  }
}
