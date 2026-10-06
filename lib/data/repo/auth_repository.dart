import 'package:flutter/cupertino.dart';
import 'package:nick/common/http_client.dart';
import 'package:nick/data/auth_info.dart';
import 'package:nick/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(
  dataSource: AuthRemoteDataSource(httpClient: httpClient),
);

abstract class IAuthRepository {
  Future<void> login(String userName, String password);

  Future<void> singUp(String userName, String password);

  Future<void> refreshToken();

  Future<void> singOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier = ValueNotifier(
    null,
  );
  final IAuthDataSource dataSource;

  AuthRepository({required this.dataSource});

  static bool isUserLogin() {
    return authChangeNotifier.value != null &&
        authChangeNotifier.value!.accessToken.isNotEmpty;
  }

  @override
  Future<void> login(String userName, String password) async {
    final AuthInfo authInfo = await dataSource.login(userName, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> singUp(String userName, String password) async {
    final AuthInfo authInfo = await dataSource.singUp(userName, password);
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      AuthInfo authInfo = await dataSource.refreshToken(
        authChangeNotifier.value!.refreshToken,
      );
      debugPrint('refresh token is: ${authInfo.refreshToken}');
      _persistAuthTokens(authInfo);
    }
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';
    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    final String email = sharedPreferences.getString("email") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(
        accessToken: accessToken,
        refreshToken: refreshToken,
        email: email,
      );
    }
  }

  @override
  Future<void> singOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}
