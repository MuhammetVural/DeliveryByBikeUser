import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_by_bike_users/models/sellers_model.dart';
import 'package:delivery_by_bike_users/widgets/menus_card_design_widget.dart';
import 'package:delivery_by_bike_users/widgets/items_card_design.dart';

import 'package:delivery_by_bike_users/widgets/my_drawer.dart';
import 'package:delivery_by_bike_users/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assistantMethods/card_Item_counter.dart';
import '../global/global.dart';
import '../models/menus_model.dart';
import 'card_screen.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  final String? sellerUID;
  const MenusScreen({super.key,  this.model, this.sellerUID});


  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Stack(
            children: [
              IconButton(
                icon:  Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor,),
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardScreen(sellerUID: widget.sellerUID)));

                  //send user to cart screen
                },
              ),
              Positioned(
                child: Stack(
                  children:  [
                     Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.red,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                     // child: Text('0', style: TextStyle(color: Colors.white, fontSize: 12),),
                      child: Center(
                        child: Consumer<CardItemCounter>(
                          builder: (context, counter, c)
                          {
                            return Text(
                              counter.count.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
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
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(),
        ),
        title: Text(sharedPreferences!.getString("name")!,),
        centerTitle: true,


      ),
      drawer: const MyDrawer(),
      body:  SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(

          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                '${widget.model!.sellerName} Menus',
                style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,), //textAlign: TextAlign.start,
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("sellers").doc(widget.model!.sellerUID).collection("menus").orderBy("publishedDate", descending: true)
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
                            Menus model = Menus.fromJson(
                                snapshot.data!.docs[index].data());
                            return MenusCardDesignWidget(
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
