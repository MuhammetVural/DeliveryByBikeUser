import 'dart:async';

import 'package:delivery_by_bike_users/widgets/menus_card_design_widget.dart';
import 'package:delivery_by_bike_users/widgets/sellers_card_design.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_by_bike_users/widgets/info_design.dart';
import 'package:delivery_by_bike_users/widgets/my_drawer.dart';
import 'package:delivery_by_bike_users/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global/global.dart';
import '../models/sellers_model.dart';


// LatLng SOURCE_LOCATION = LatLng(sharedPreferences!.getDouble("lat")!, sharedPreferences!.getDouble("lng")!);
LatLng SOURCE_LOCATION = LatLng(30, 39);
LatLng DEST_LOCATION = LatLng(39.7866393, 30.509036);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://static01.nyt.com/images/2020/05/20/dining/aw-charred-scallion-dip/aw-charred-scallion-dip-master768-v2.jpg?w=1280&q=75'
          'https://media-cdn.tripadvisor.com/media/photo-s/1c/2f/33/2d/healthy-bowl-frische.jpg'
          'https://static01.nyt.com/images/2020/05/20/dining/aw-charred-scallion-dip/aw-charred-scallion-dip-master768-v2.jpg?w=1280&q=75'
          'https://cdn.vox-cdn.com/thumbor/OO-xRgZvA_msWWvniol6AcoaV4s=/0x0:6000x4000/1075x1075/filters:focal(2520x1520:3480x2480):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/71262429/Le_Fantome.0.jpg'
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'No. ${imgList.indexOf(item)} image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
          title: Text(
            sharedPreferences!.getString("name")!,
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics() ,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 1.5,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeOutExpo,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: imageSliders,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(

              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("sellers")
                      .snapshots(),
                  builder: (context, snapshot) {
                    return !snapshot.hasData ? Padding(padding: EdgeInsets.all(0), child: circularProgress(),) :
                       Container(
                         padding: EdgeInsets.only(top: 15, bottom: 40),
                         height: 700,
                         width: MediaQuery.of(context).size.width,
                         child: ListView.builder(

                                itemCount: snapshot.data!.docs.length,

                                  itemBuilder: (context, index) {
                                  Sellers smodel = Sellers.fromJson(snapshot.data!.docs[index].data());
                                  return SellersCardDesign( model: smodel, context: context,);
                                  }

                                      ),
                       );

                  }),
            )
          ],
        ));
  }
}
