import 'package:flutter/cupertino.dart';

import '../global/global.dart';

class CardItemCounter extends ChangeNotifier
{
  int cardListItemCounter = sharedPreferences?.getStringList("userCard")?.length  ?? - 1 ;
  int get count => cardListItemCounter -1;

  Future<void> displayCardListItemsNumber() async
  {
    cardListItemCounter = sharedPreferences?.getStringList("userCard")?.length ?? - 1 ;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}