
part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable{
  @override
  List<Object?> get props =>[];
}

final class HomeLoading extends HomeState {

}


class HomeError extends HomeState{
  final AppException exception;

  HomeError({required this.exception});
}

class HomeSuccess extends HomeState{
  final List<BannerEntity> banners;
  final List<ProductEntity> latestProducts;
  final List<ProductEntity> papularProducts;

  HomeSuccess({required this.banners, required this.latestProducts, required this.papularProducts});
}
