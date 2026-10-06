import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/auth_info.dart';
import 'package:nick/data/cart_response.dart';
import 'package:nick/data/repo/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItem(emit, event.isRefresh);
        }
      } else if (event is CartDeleteBottonClicked) {
        if (state is CartSuccess) {
          final successState = (state as CartSuccess);
          final cartItem = successState.cartResponse.cartItems.firstWhere(
            (product) => product.id == event.cartItemId,
          );
          cartItem.isLoading = true;
          emit(CartSuccess(cartResponse: successState.cartResponse));
        }

        await cartRepository.delete(event.cartItemId);
        await cartRepository.count();
        if (state is CartSuccess) {
          final successState = (state as CartSuccess);
          successState.cartResponse.cartItems.removeWhere(
            (item) => item.id == event.cartItemId,
          );
          if (successState.cartResponse.cartItems.isEmpty) {
            emit(CartEmpty());
          } else {
            emit(calculatePriceInfo(successState.cartResponse));
          }
        }
      } else if (event is CartAuthInfoChanged) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.accessToken.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItem(emit, false);
          }
        }






      } else if (event is CartInCreaseBottonClicked ||
          event is CartDeCreaseBottonClicked) {
        try {
          int cartItemId = 0;
          if (event is CartInCreaseBottonClicked) {
            cartItemId = event.cartItemId;
          } else if (event is CartDeCreaseBottonClicked) {
            cartItemId = event.cartItemId;
          }

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final cartItem = successState.cartResponse.cartItems.firstWhere(
              (product) => product.id == cartItemId,
            );
            cartItem.isChangeLoading=true;
            emit(CartSuccess(cartResponse: successState.cartResponse));
            final newCont = event is CartInCreaseBottonClicked
                ? ++cartItem.count
                : --cartItem.count;

            await cartRepository.changeCount(newCont,cartItemId);
            await cartRepository.count();
            cartItem
              ..count = newCont
              ..isChangeLoading = false;

            emit(calculatePriceInfo(successState.cartResponse));
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }else if(event is CartRefresh){
        await loadCartItem(emit, false);
      }
    });
  }

  Future<void> loadCartItem(Emitter<CartState> emit, bool isRefresh) async {
    try {
      if (!isRefresh) {
        emit(CartLoading());
      }
      final cartItems = await cartRepository.getAll();
      if (cartItems.cartItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(CartSuccess(cartResponse: cartItems));
      }
    } catch (e) {
      emit(CartError(exception: AppException()));
    }
  }

  CartSuccess calculatePriceInfo(CartResponse cartResponse) {
    int totalPrice = 0;
    int payablePrice = 0;
    int shippingCost = 0;

    cartResponse.cartItems.forEach((cartItem) {
      totalPrice += cartItem.product.previousPrice * cartItem.count;
      payablePrice += cartItem.product.price * cartItem.count;
    });
    shippingCost = payablePrice > 350000 ? 0 : 35000;

    cartResponse.totalPrice = totalPrice;
    cartResponse.payablePrice = payablePrice;
    cartResponse.shippingCost = shippingCost;
    return CartSuccess(cartResponse: cartResponse);
  }
}
