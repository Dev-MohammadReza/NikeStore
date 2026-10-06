part of 'product_list_bloc.dart';

@immutable
sealed class ProductListEvent {}



class ProductListStarted extends ProductListEvent{
  final int sort;
  final String searchTerm;
  ProductListStarted({required this.sort, required this.searchTerm});
}