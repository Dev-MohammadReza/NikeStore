import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:nick/common/exception.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/ui/auth/auth_error_handler.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  bool isLogin;
  final IAuthRepository repository;
  final ICartRepository cartRepository;
  AuthBloc(this.repository, {this.isLogin = true, required this.cartRepository}) : super(AuthInitial(isLogin: isLogin)) {
    on<AuthEvent>((event, emit) async {
      try{
        if (event is AuthClickOnBotton) {
          emit(AuthLoading(isLogin: isLogin));
          if (isLogin == true) {
            await repository.login(event.userName, event.password);
            await cartRepository.count();
            emit(AuthSuccess(isLogin: isLogin));
          }else{
            await repository.singUp(event.userName, event.password);
            emit(AuthSuccess(isLogin: isLogin));
          }
        }else if(event is AuthClickOnChangeMode){
          isLogin=!isLogin;
          emit(AuthInitial(isLogin: isLogin));
        }
      }catch(e){
       final appException = AuthErrorHandler.handle(e);
       emit(AuthError(exception: appException, isLogin: isLogin));
      }
    });
  }
}
