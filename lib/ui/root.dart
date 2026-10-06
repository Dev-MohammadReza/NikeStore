import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick/data/repo/auth_repository.dart';
import 'package:nick/data/repo/cart_repository.dart';
import 'package:nick/ui/cart/cart.dart';
import 'package:nick/ui/home/home.dart';
import 'package:nick/ui/profile/profilr.dart';
import 'package:nick/ui/widgets/badge.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenTapIndex = homeIndex;
  final List<int> _history = [];

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _articleKey = GlobalKey();
  GlobalKey<NavigatorState> _searchKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _articleKey,
    profileIndex: _searchKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenTapIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenTapIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: ValueListenableBuilder<int>(
                valueListenable: CartRepository.countValueNotifier,
                builder: (context, value, child) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(CupertinoIcons.cart),
                      Positioned(
                        right: -8,
                        top: -5,
                        child: CartBadge(value: value),
                      ),
                    ],
                  );
                },
              ),
              label: 'سبد خرید',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'پروفایل',
            ),
          ],
          currentIndex: selectedScreenTapIndex,
          onTap: (value) {
            setState(() {
              _history.remove(selectedScreenTapIndex);
              _history.add(selectedScreenTapIndex);
              selectedScreenTapIndex = value;
            });
          },
        ),
        body: IndexedStack(
          index: selectedScreenTapIndex,
          children: [
            _navigator(_homeKey, homeIndex, HomeScreen()),
            _navigator(_articleKey, cartIndex, CartScreen()),
            _navigator(
              _searchKey,
              profileIndex,
              ProfileScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenTapIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                offstage: selectedScreenTapIndex != index,
                child: child,
              ),
            ),
          );
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
