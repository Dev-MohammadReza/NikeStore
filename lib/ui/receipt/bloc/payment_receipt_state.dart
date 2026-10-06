part of 'payment_receipt_bloc.dart';

@immutable
sealed class PaymentReceiptState {}

final class PaymentReceiptLoading extends PaymentReceiptState {}


class PaymentReceiptError extends PaymentReceiptState{
  final AppException exception;

  PaymentReceiptError({required this.exception});
}


class PaymentReceiptSuccess extends PaymentReceiptState{
  final PaymentReceiptData data;

  PaymentReceiptSuccess({required this.data});
}