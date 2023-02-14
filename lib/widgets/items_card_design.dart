import 'package:delivery_by_bike_users/Screens/itemsScreen.dart';
import 'package:delivery_by_bike_users/Screens/items_detail_screen.dart';
import 'package:delivery_by_bike_users/models/items_model.dart';
import 'package:delivery_by_bike_users/models/menus_model.dart';
import 'package:flutter/material.dart';


class ItemsCardDesign extends StatefulWidget {

  Items? model ;
  BuildContext? context;

  ItemsCardDesign({this.model, this.context});

  @override
  _ItemsCardDesignState createState() => _ItemsCardDesignState();
}

class _ItemsCardDesignState extends State<ItemsCardDesign> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemsScreen(model: widget.model)));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    //  Ink.image(image: AssetImage(sharedPreferences!.getString("photoUrl")!)),
                    // Image.asset('assets/slider/2.jpg')
                    Ink.image(
                      //image: const NetworkImage("assets/slider/2.jpg"),
                      image:  NetworkImage(widget.model?.thumbnailUrl ?? "Resim Bulunamadı",),
                      height: 150,
                      fit: BoxFit.cover,
                      child: InkWell(
                        onTap: () {

                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ItemsDetailScreen(model: widget.model)));

                          // should inkwell onTap inside copy paste

                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0),
                                Colors.black.withOpacity(0.1)
                              ])),
                      child: Text(
                          widget.model?.title ?? "title bunumaandı2",

                        style: const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 20, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.model?.title ?? "", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                      Text(widget.model?.shortInfo ?? "", style: TextStyle(fontSize: 11, ),),

                    ],
                  ),
                ),
                ButtonBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
