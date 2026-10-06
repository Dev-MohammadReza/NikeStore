part of 'shipping_bloc.dart';

@immutable
sealed class ShippingEvent {}




class ShippingCreatOrder extends ShippingEvent{
  final CreateOrderParams params;

  ShippingCreatOrder({required this.params});
}