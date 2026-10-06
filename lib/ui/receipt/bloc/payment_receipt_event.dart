part of 'payment_receipt_bloc.dart';

@immutable
sealed class PaymentReceiptEvent {}




class PaymentReceiptStarted extends PaymentReceiptEvent{
  final int orderId;

  PaymentReceiptStarted({required this.orderId});
}