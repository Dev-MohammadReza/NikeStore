import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int value;

  const CartBadge({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value>0,
      child: Container(
        height: 18,
        width: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Text(value.toString(),style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12
        ),),
      ),
    );
  }
}
