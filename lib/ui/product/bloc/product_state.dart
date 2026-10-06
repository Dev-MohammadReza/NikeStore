part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}


class ProductError extends ProductState{
  final AppException exception;

  ProductError({required this.exception});
  @override
  List<Object?> get props => [exception];
}
class ProductLoading extends ProductState{

}


class ProductSuccess extends ProductState{
  final AddToCartResponse response;

  ProductSuccess({required this.response});
}