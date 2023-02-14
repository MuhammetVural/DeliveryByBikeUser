import 'dart:ui';

import 'package:delivery_by_bike_users/Screens/card_screen2.dart';
import 'package:delivery_by_bike_users/models/items_model.dart';
import 'package:delivery_by_bike_users/widgets/reuseable_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

import '../assistantMethods/assistant_method.dart';
import '../assistantMethods/card_Item_counter.dart';
import '../widgets/special_appbar.dart';
import 'card_screen.dart';
import 'itemsScreen.dart';

class ItemsDetailScreen extends StatefulWidget {
  final String? sellerUID;
  final Items? model;

  const ItemsDetailScreen({Key? key, this.model, this.sellerUID}) : super(key: key);

  @override
  State<ItemsDetailScreen> createState() => _ItemsDetailScreenState();
}

class _ItemsDetailScreenState extends State<ItemsDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon:  Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor,),
                    onPressed: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const CardScreen2()));

                      //send user to cart screen
                    },
                  ),
                  Positioned(
                    child: Stack(
                      children:  [
                        const Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        Positioned(
                          top: 3,
                          right: 4,
                        //  child: Text('0', style: TextStyle(color: Colors.white, fontSize: 12),),
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
            title: Text(
              widget.model!.title.toString(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            leadingWidth: 80,
            floating: true,
            expandedHeight: 275,
            backgroundColor: Colors.black,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.model!.thumbnailUrl.toString(),
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(0.5),
              ),
              stretchModes: const [
                StretchMode.blurBackground,
              ],

              // background: Image.asset(
              //  'assets/images/BikeAnimated.png', fit: BoxFit.cover,),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: NumberInputPrefabbed.squaredButtons(
                min: 1,
                max: 9,
                initialValue: 1,
                decIconColor: Theme.of(context).primaryColor,
                incIconColor: Theme.of(context).primaryColor,
                scaleHeight: 0.7,
                controller: counterTextEditingController,
                incDecBgColor: Colors.black,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.model!.title.toString(),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.model!.price.toString()}\u{20BA}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black54),
                    child: Text(
                      widget.model!.longDescription.toString(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${widget.model!.price.toString()}\u{20BA}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  normalButton(context, "Basket",
                      //check if item exist already in cart
                      //add to cart
                      () {

                    List<String> separateItemIDsList = separateItemIDs();
                    separateItemIDsList.contains(
                      widget.model?.itemID,
                    )
                        ? Fluttertoast.showToast(
                            msg: "Item is already in Cart.")
                        : addItemToCard(
                            widget.model?.itemID, context, );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
