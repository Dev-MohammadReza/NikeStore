import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/banner.dart';
import 'package:nick/data/product.dart';
import 'package:nick/data/repo/banner_repository.dart';
import 'package:nick/data/repo/product_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IProductRepository productRepository;

  HomeBloc({required this.bannerRepository, required this.productRepository})
    : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        emit(HomeLoading());
        try {
          final banners = await bannerRepository.getAll();
          final latestProducts = await productRepository.getAll(
            ProductSort.latest,
          );
          final papularProducts = await productRepository.getAll(
            ProductSort.popular,
          );
          emit(
            HomeSuccess(
              banners: banners,
              latestProducts: latestProducts,
              papularProducts: papularProducts,
            ),
          );
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
