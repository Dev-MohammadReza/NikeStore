import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defultScrollPhysics =  BouncingScrollPhysics();


extension PriceLable on int{
  String get withPriceLabel => this>0?'$separatedByComma تومان ':'رایگان';

  String get separatedByComma{
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

