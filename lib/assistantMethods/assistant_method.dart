import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import 'card_Item_counter.dart';



addItemToCard(String? itemID, BuildContext context,) {
  List<String>? tempList = sharedPreferences?.getStringList("userCard") ?? [];
  tempList.add(itemID!);

  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser?.uid)
      .update({
    "userCard": tempList,
  }).then((value) {
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    sharedPreferences?.setStringList("userCard", tempList);

    Provider.of<CardItemCounter>(context, listen: false).displayCardListItemsNumber();

  });
}


separateItemIDs()
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCard")!;

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");

    //56557657
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Items List now = ");
  print(separateItemIDsList);

  return defaultItemList;
}

separateItemQuantities()
{
  List<int> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = sharedPreferences?.getStringList("userCard") ?? [];

  for(i; i<defaultItemList.length; i++)
  {
    //56557657:7
    String item = defaultItemList[i].toString();


    //0=:
    //1=7
    //:7
    List<String> listItemCharacters = item.split(":").toList();

    //7
    var quanNumber = int.parse(listItemCharacters[1].toString());

    print("\nThis is Quantity Number = " + quanNumber.toString());

    separateItemQuantityList.add(quanNumber);
  }

  print("\nThis is Quantity List now = ");
  print(separateItemQuantityList);

  return separateItemQuantityList;
}



