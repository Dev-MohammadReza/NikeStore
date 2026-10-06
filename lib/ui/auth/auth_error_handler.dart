
import 'package:dio/dio.dart';
import 'package:nick/common/exception.dart';

class AuthErrorHandler {
  static AppException handle(Object error) {
    // خطای سفارشی برنامه
    if (error is AppException) {
      return error;
    }

    // خطاهای مربوط به Dio و ارتباط با سرور
    if (error is DioException) {
      // اینترنت قطع است یا اتصال برقرار نمی‌شود
      if (error.type == DioExceptionType.connectionError) {
        return AppException(
          message: 'اتصال اینترنت برقرار نیست. لطفاً اینترنت خود را بررسی کنید.',
        );
      }

      // زمان اتصال یا دریافت پاسخ تمام شده
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return  AppException(
          message: 'زمان اتصال به سرور به پایان رسید. لطفاً دوباره تلاش کنید.',
        );
      }

      // پاسخ HTTP از سرور دریافت شده
      final statusCode = error.response?.statusCode;

      switch (statusCode) {
        case 401:
          return  AppException(
            message: 'ایمیل یا رمز عبور نادرست است.',
            statusCode: 401,
          );

        case 422:
          return  AppException(
            message: 'این ایمیل قبلاً ثبت‌نام کرده است.',
            statusCode: 409,
          );

        case 400:
          return  AppException(
            message: 'اطلاعات واردشده معتبر نیست.',
            statusCode: 400,
          );

        case 403:
          return  AppException(
            message: 'اجازه انجام این عملیات را ندارید.',
            statusCode: 403,
          );

        case 404:
          return  AppException(
            message: 'آدرس یا منبع موردنظر پیدا نشد.',
            statusCode: 404,
          );

        case 429:
          return  AppException(
            message: 'تعداد درخواست‌ها بیش از حد مجاز است. کمی بعد دوباره تلاش کنید.',
            statusCode: 429,
          );

        case 500:
        case 502:
        case 503:
        case 504:
          return AppException(
            message: 'مشکلی در سرور رخ داده است. لطفاً بعداً دوباره تلاش کنید.',
            statusCode: statusCode,
          );

        default:
          return AppException(
            message: 'خطایی در ارتباط با سرور رخ داده است.',
            statusCode: statusCode,
          );
      }
    }

    // خطاهای پیش‌بینی‌نشده
    return  AppException(
      message: 'خطای غیرمنتظره‌ای رخ داده است. لطفاً دوباره تلاش کنید.',
    );
  }
}