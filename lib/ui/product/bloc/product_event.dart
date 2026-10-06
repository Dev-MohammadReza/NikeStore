part of 'product_bloc.dart';

@immutable
sealed class ProductEvent extends Equatable{
  @override
  List<Object?> get props => [];
}



class ProductClickOnAddBotton extends ProductEvent{
  final int productId;

  ProductClickOnAddBotton({required this.productId});
}