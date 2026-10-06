import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/add_to_cart_response.dart';
import 'package:nick/data/repo/cart_repository.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc({required this.cartRepository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async{
      if(event is ProductClickOnAddBotton){
        try{
          emit(ProductLoading());
          final response = await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductSuccess(response: response));
        }catch(e){
          emit(ProductError(exception: AppException()));
        }
      }
    });
  }
}
