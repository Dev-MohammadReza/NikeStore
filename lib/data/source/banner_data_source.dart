




import 'package:dio/dio.dart';
import 'package:nick/data/banner.dart';
import 'package:nick/data/common/response_validator.dart';

abstract class IBannerDataSource{
  Future<List<BannerEntity>> getAll();
}



class BannerRemoteDataSource with HttpResponseValidator implements IBannerDataSource{
  final Dio httpClient;

  BannerRemoteDataSource(this.httpClient);
  @override
  Future<List<BannerEntity>> getAll() async{
    final response = await httpClient.get('banner/slider');
    validateResponse(response);
    final List<BannerEntity> banners = [];
    (response.data as List).forEach((banner){
      banners.add(BannerEntity.fromJson(banner));
    });
    return banners;
  }
  
}