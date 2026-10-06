import 'package:dio/dio.dart';
import 'package:nick/common/constants.dart';
import 'package:nick/data/auth_info.dart';
import 'package:nick/data/common/response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String userName, String password);

  Future<AuthInfo> singUp(String userName, String password);

  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource({required this.httpClient});

  @override
  Future<AuthInfo> login(String userName, String password) async {
    final response = await httpClient.post(
      'auth/token',
      data: {
        "grant_type": "password",
        "client_id": 2,
        "client_secret": Constants.clientSecret,
        "username": userName,
        "password": password,
      },
    );
    validateResponse(response);
    return AuthInfo(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
      email: userName
    );
  }

  @override
  Future<AuthInfo> singUp(String userName, String password) async {
    final response = await httpClient.post(
      'user/register',
      data: {"email": userName, "password": password},
    );
    validateResponse(response);
    return login(userName, password);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final response = await httpClient.post(
      'auth/token',
      data: {
        "grant_type": "refresh_token",
        "refresh_token": token,
        "client_id": 2,
        "client_secret": Constants.clientSecret,
      },
    );
    validateResponse(response);
    return AuthInfo(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
      email: ''
    );
  }
}
