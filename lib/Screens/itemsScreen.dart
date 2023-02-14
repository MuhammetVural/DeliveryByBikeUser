import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_by_bike_users/Screens/card_screen2.dart';
import 'package:delivery_by_bike_users/models/items_model.dart';
import 'package:delivery_by_bike_users/models/menus_model.dart';
import 'package:delivery_by_bike_users/uploadScreens/items_upload_screen.dart';
import 'package:delivery_by_bike_users/uploadScreens/menus_upload_screen.dart';
import 'package:delivery_by_bike_users/widgets/menus_card_design_widget.dart';
import 'package:delivery_by_bike_users/widgets/items_card_design.dart';
import 'package:delivery_by_bike_users/widgets/my_drawer.dart';
import 'package:delivery_by_bike_users/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_by_bike_users/assistantMethods/card_Item_counter.dart';
import '../global/global.dart';
import 'card_screen.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  final String? sellerUID;

  const ItemsScreen({super.key, this.model, this.sellerUID});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
          title: Text(
            sharedPreferences?.getString("name") ?? '',
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CardScreen2()));
                    //send user to cart screen
                  },
                ),
                Positioned(
                  child: Stack(
                    children:  [
                      Icon(
                        Icons.brightness_1,
                        size: 19.0,
                        color: Colors.red,
                      ),
                      Positioned(
                        top: 3,
                        right: 5,
                        //child: Text('0', style: TextStyle(color: Colors.white, fontSize: 12),),
                        child: Center(
                          child: Consumer<CardItemCounter>(
                            builder: (context, counter, c)
                            {
                              return Text(
                                counter.count.toString(),
                                style:  TextStyle(color: Colors.white, fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                widget.model!.menuTitle.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ), //textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(widget.model!.sellerUID)
                      .collection("menus")
                      .doc(widget.model!.menuID)
                      .collection("items")
                      .orderBy("publishedDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Padding(
                            padding: EdgeInsets.all(0),
                            child: circularProgress(),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 15, bottom: 40),
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true, //important
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Items model = Items.fromJson(
                                      snapshot.data!.docs[index].data());
                                  return ItemsCardDesign(
                                    model: model,
                                    context: context,
                                  );
                                }),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
