import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/order.dart';
import 'package:nick/data/repo/order_repository.dart';

part 'order_history_event.dart';

part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final IOrderRepository orderRepository;

  OrderHistoryBloc({required this.orderRepository})
    : super(OrderHistoryInitial()) {
    on<OrderHistoryEvent>((event, emit) async {
      if (event is OrderHistoryStarted) {
        try {
          emit(OrderHistoryLoading());
          final orders = await orderRepository.getOrders();
          emit(OrderHistorySuccess(orders: orders));
        } catch (e) {
          emit(OrderHistoryError(exception: AppException()));
        }
      }
    });
  }
}
