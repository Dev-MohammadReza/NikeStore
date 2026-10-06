import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/order.dart';
import 'package:nick/data/repo/order_repository.dart';

part 'shipping_event.dart';

part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository orderRepository;

  ShippingBloc({required this.orderRepository}) : super(ShippingInitial()) {
    on<ShippingEvent>((event, emit) async {
      if (event is ShippingCreatOrder) {
        try {
          emit(ShippingLoading());
          final result = await orderRepository.create(event.params);
          emit(ShippingSuccess(result: result));
        } catch (e) {
          emit(ShippingError(exception: AppException()));
        }
      }
    });
  }
}
