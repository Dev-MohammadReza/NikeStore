import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nick/data/favorite_manager.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/theme.dart';
import 'package:nick/ui/cart/bloc/cart_bloc.dart';
import 'package:nick/ui/root.dart';

void main() async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle defultTextStyle = TextStyle(
      color: LightThemeColors.primaryTextColor,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) {
            final cartBloc = CartBloc(cartRepository);
            cartBloc.add(
              CartStarted(authInfo: AuthRepository.authChangeNotifier.value),
            );
            return cartBloc;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: LightThemeColors.secondaryTextColor.withOpacity(0.3),
              ),
            ),
          ),
          dividerTheme: DividerThemeData(color: Colors.grey.shade300),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: LightThemeColors.secondaryColor,
          ),
          colorScheme: ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white,
            outline: Colors.grey.shade400,
            surface: Colors.white,
            surfaceVariant: Color(0xffF5F5F5),
          ),
          textTheme: TextTheme(
            titleLarge: defultTextStyle.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: defultTextStyle.copyWith(
              color: LightThemeColors.secondaryTextColor,
            ),
            bodyMedium: defultTextStyle,
            bodyLarge: defultTextStyle.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            headlineSmall: defultTextStyle,
            bodySmall: defultTextStyle.copyWith(
              color: LightThemeColors.secondaryTextColor,
            ),
          ),
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: const RootScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
