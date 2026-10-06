part of 'cart_bloc.dart';

@immutable
sealed class CartState{
}

final class CartLoading extends CartState {}



class CartError extends CartState{
  final AppException exception;

  CartError({required this.exception});

}

class CartSuccess extends CartState{
  final CartResponse cartResponse;

  CartSuccess({required this.cartResponse});

}

class CartAuthRequired extends CartState{
}


class CartEmpty extends CartState{

}

