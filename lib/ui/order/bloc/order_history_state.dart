part of 'order_history_bloc.dart';

@immutable
sealed class OrderHistoryState {}

final class OrderHistoryInitial extends OrderHistoryState {}



class OrderHistoryLoading extends OrderHistoryState{

}

class OrderHistoryError extends OrderHistoryState{
  final AppException exception;

  OrderHistoryError({required this.exception});
}

class OrderHistorySuccess extends OrderHistoryState{
  final List<OrderEntity> orders;

  OrderHistorySuccess({required this.orders});
}