part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}




class CartStarted extends CartEvent{
final AuthInfo? authInfo;
final bool isRefresh;
  CartStarted({required this.authInfo,this.isRefresh=false});
}

class CartRefresh extends CartEvent{

}

class CartAuthInfoChanged extends CartEvent{
  final AuthInfo? authInfo;

  CartAuthInfoChanged({required this.authInfo});
}

class CartDeleteBottonClicked extends CartEvent{
  final int cartItemId;

  CartDeleteBottonClicked({required this.cartItemId});
}

class CartInCreaseBottonClicked extends CartEvent{
  final int cartItemId;

  CartInCreaseBottonClicked({required this.cartItemId});
}

class CartDeCreaseBottonClicked extends CartEvent{
  final int cartItemId;

  CartDeCreaseBottonClicked({required this.cartItemId});
}