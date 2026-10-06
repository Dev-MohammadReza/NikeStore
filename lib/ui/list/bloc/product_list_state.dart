part of 'product_list_bloc.dart';

@immutable
sealed class ProductListState {}

final class ProductListLoading extends ProductListState {}

class ProductListError extends ProductListState {
  final AppException exception;

  ProductListError({required this.exception});
}

class ProductListSuccess extends ProductListState {
  final int sort;
  final List<ProductEntity> products;
  final List<String> names;

  ProductListSuccess({
    required this.sort,
    required this.products,
    required this.names,
  });
}

class ProductListEmpty extends ProductListState{
  final String emptyMassage;

  ProductListEmpty({required this.emptyMassage});
}
