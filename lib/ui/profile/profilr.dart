import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick/data/auth_info.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/ui/auth/auth.dart';
import 'package:nick/ui/favorite/favorite.dart';
import 'package:nick/ui/order/order_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('پروفایل'), centerTitle: true),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authInfo, child) {
          final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
          return Center(
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.only(top: 12, bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                      color: themeData.colorScheme.outline,
                    ),
                  ),
                  child: Image.asset('assets/img/nike_logo.png'),
                ),
                Text(isLogin ? authInfo.email : 'کاربر میهمان'),
                SizedBox(height: 32),
                Divider(height: 1),
                _rowWidget(
                  rowTitle: 'لیست علاقه مندی ها',
                  rowIcon: CupertinoIcons.heart,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FavoriteListScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                _rowWidget(
                  rowTitle: 'سوابق سفارش',
                  rowIcon: CupertinoIcons.cart,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
                  },
                ),
                Divider(height: 1),
                _rowWidget(
                  rowTitle: isLogin
                      ? 'خروج از حساب کاربری'
                      : 'ورود به حساب کاربری',
                  rowIcon: isLogin
                      ? CupertinoIcons.arrow_right_square
                      : CupertinoIcons.arrow_left_square,
                  onTap: () {
                    if (isLogin) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: AlertDialog(
                              title: Text('خروج از حساب کاربری'),
                              content: Text(
                                'آیا میخواهید از حساب خود خارج شوید؟',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('خیر'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    CartRepository.countValueNotifier.value = 0;
                                    authRepository.singOut();
                                  },
                                  child: Text('بله'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    }
                  },
                ),
                Divider(height: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _rowWidget extends StatelessWidget {
  final String rowTitle;
  final IconData rowIcon;
  final GestureTapCallback onTap;

  const _rowWidget({
    super.key,
    required this.rowTitle,
    required this.rowIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: EdgeInsets.only(right: 12),
        child: Row(
          children: [Icon(rowIcon), SizedBox(width: 8), Text(rowTitle)],
        ),
      ),
    );
  }
}
