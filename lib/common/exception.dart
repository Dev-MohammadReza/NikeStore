


class AppException implements Exception{
  final String message;
  final int? statusCode;
  AppException({this.statusCode, this.message = 'ارور نامشخص'});
  @override
  String toString() => message;
}








