import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_by_bike_users/assistantMethods/assistant_method.dart';
import 'package:delivery_by_bike_users/widgets/card_screen_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assistantMethods/card_Item_counter.dart';
import '../global/global.dart';
import '../models/items_model.dart';
import '../widgets/progress_bar.dart';

class CardScreen extends StatefulWidget {


  BuildContext? context;



  final String? sellerUID;
   CardScreen({Key? key, this.sellerUID, this.context, }) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {

  @override
  void initState(){
    super.initState();
    separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
          title: Text(
            'Basket', textAlign: TextAlign.center,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  CardScreen(sellerUID: widget.sellerUID)));
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
          ]
          ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: (){}, backgroundColor: Colors.black, child:  Icon(Icons.delete, color: Theme.of(context).primaryColor,),),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "btn2",
              onPressed: (){}, backgroundColor: Colors.black, child:  Icon(Icons.motorcycle, color: Theme.of(context).primaryColor,),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
               "Total Amount" ,
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
                      .collection("items")
                      .where("itemID", whereIn: sharedPreferences!.getStringList("userCard")!)
                      .orderBy("publishedDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData
                        ? Padding(
                      padding: EdgeInsets.all(0),
                      child: circularProgress(),) : snapshot.data!.docs.length == 0 ? Container(child: Text('boş'),)
                        : Container(
                      padding: EdgeInsets.only(top: 15, bottom: 40),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true, //important
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            Items model = Items.fromJson(
                                snapshot.data!.docs[index].data());
                            return CardScreenDesign(
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
