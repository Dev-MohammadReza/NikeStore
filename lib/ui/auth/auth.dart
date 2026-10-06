import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController(
    text: 'test@gmail.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '123456',
  );

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: themeData.copyWith(
          snackBarTheme: SnackBarThemeData(
            backgroundColor: themeData.colorScheme.primary,
            contentTextStyle: TextStyle(fontSize: 16)
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: themeData.colorScheme.onSecondary),
            border: OutlineInputBorder(),
          ),
        ),
        child: Scaffold(
          backgroundColor: themeData.colorScheme.secondary,
          body: BlocProvider<AuthBloc>(
            create: (context) {
              final authBloc = AuthBloc(authRepository,cartRepository: cartRepository);
              authBloc.stream.forEach((state) {
                if (state is AuthSuccess) {
                  Navigator.pop(context);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.exception.message)),
                  );
                }
              });
              authBloc.add(AuthStarted());
              return authBloc;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthInitial ||
                      current is AuthLoading ||
                      current is AuthError;
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/img/nike_logo.png',
                        color: themeData.colorScheme.onSecondary,
                        width: 120,
                      ),
                      SizedBox(height: 16),
                      Text(
                        state.isLogin ? 'خوش آمدید' : 'ثبت نام',
                        style: themeData.textTheme.headlineSmall!.copyWith(
                          color: themeData.colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.isLogin
                            ? 'لطفا وارد حساب کاربری خود شوید'
                            : 'لطفا ایمیل و پسورد خود را تعیین کنید',
                        style: TextStyle(
                          color: themeData.colorScheme.onSecondary,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(label: Text('ایمیل')),
                      ),
                      SizedBox(height: 12),
                      _TextFiled(controller: passwordController),
                      SizedBox(height: 16),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: themeData.colorScheme.onSecondary,
                          foregroundColor: Colors.black,
                          minimumSize: Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthClickOnBotton(
                              userName: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                        icon: state is AuthLoading
                            ? CircularProgressIndicator()
                            : Text(state.isLogin ? 'ورود' : 'ثبت نام'),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.isLogin
                                ? 'حساب کاربری ندارید؟'
                                : 'حساب کاربری دارید؟',
                            style: TextStyle(
                              color: themeData.colorScheme.onSecondary,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<AuthBloc>(
                                context,
                              ).add(AuthClickOnChangeMode());
                            },
                            child: Text(
                              state.isLogin ? 'ثبت نام' : 'ورود',
                              style: TextStyle(
                                color: themeData.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextFiled extends StatefulWidget {
  final TextEditingController controller;

  const _TextFiled({super.key, required this.controller});

  @override
  State<_TextFiled> createState() => _TextFiledState();
}

class _TextFiledState extends State<_TextFiled> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      obscureText: obscureText,
      decoration: InputDecoration(
        label: Text('پسورد'),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
