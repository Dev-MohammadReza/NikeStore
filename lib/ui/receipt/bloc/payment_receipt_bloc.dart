import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/payment_receipt_data.dart';
import 'package:nick/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';

part 'payment_receipt_state.dart';

class PaymentReceiptBloc
    extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository orderRepository;

  PaymentReceiptBloc({required this.orderRepository})
    : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try {
          emit(PaymentReceiptLoading());
          final response = await orderRepository.getPaymentReceipt(
            event.orderId,
          );
          emit(PaymentReceiptSuccess(data: response));
        } catch (e) {
          emit(PaymentReceiptError(exception: AppException()));
        }
      }
    });
  }
}
