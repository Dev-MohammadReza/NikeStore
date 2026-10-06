import 'package:dio/dio.dart';
import 'package:nick/common/exception.dart';

mixin HttpResponseValidator {
  void validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
