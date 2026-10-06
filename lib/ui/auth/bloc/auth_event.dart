part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent{
}

class AuthClickOnBotton extends AuthEvent{
final String userName;
final String password;

  AuthClickOnBotton({required this.userName, required this.password,});
  @override
  List<Object?> get props => [userName,password];
}

class AuthClickOnChangeMode extends AuthEvent{
}