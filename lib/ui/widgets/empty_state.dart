


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget{
  final String massage;
  final Widget? callToAction;
  final Widget image;

  const EmptyView({super.key, required this.massage, this.callToAction, required this.image});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image,
          Padding(
            padding: const EdgeInsets.fromLTRB(42, 8, 42, 16),
            child: Text(massage,style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center,),
          ),
          if (callToAction!=null) callToAction!
        ],
      ),
    );
  }
}

