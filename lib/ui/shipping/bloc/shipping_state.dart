part of 'shipping_bloc.dart';

@immutable
sealed class ShippingState {}

final class ShippingInitial extends ShippingState {}

class ShippingLoading extends ShippingState {}

class ShippingError extends ShippingState {
  final AppException exception;

  ShippingError({required this.exception});
}

class ShippingSuccess extends ShippingState {
  final CreateOrderResult result;

  ShippingSuccess({required this.result});
}
