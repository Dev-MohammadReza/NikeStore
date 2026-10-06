import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/product.dart';
import 'package:nick/data/repo/product_repository.dart';

part 'product_list_event.dart';

part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository productRepository;

  ProductListBloc(this.productRepository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        try {
          emit(ProductListLoading());
          final products = event.searchTerm.isEmpty
              ? await productRepository.getAll(event.sort)
              : await productRepository.search(event.searchTerm);
          if(products.isNotEmpty){
            emit(
              ProductListSuccess(
                sort: event.sort,
                products: products,
                names: ProductSort.names,
              ),
            );
          }else{
            emit(ProductListEmpty(emptyMassage: 'محصولی با عبارت سرچ شده ای شما یافت نشد.'));
          }
        } catch (e) {
          emit(ProductListError(exception: AppException()));
        }
      }
    });
  }
}
