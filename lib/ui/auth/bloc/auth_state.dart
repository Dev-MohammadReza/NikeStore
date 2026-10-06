part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable{
  final bool isLogin;

  const AuthState({required this.isLogin});

  @override
  List<Object?> get props => [isLogin];
}

final class AuthInitial extends AuthState {
  const AuthInitial({required super.isLogin});
}


class AuthError extends AuthState{
  final AppException exception;

  const AuthError({required this.exception, required super.isLogin});
  @override
  List<Object?> get props => [exception,isLogin];
}

class AuthLoading extends AuthState{
  const AuthLoading({required super.isLogin});

}

class AuthSuccess extends AuthState{
  const AuthSuccess({required super.isLogin});

}

