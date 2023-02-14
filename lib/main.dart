
import 'package:delivery_by_bike_users/Screens/items_detail_screen.dart';
import 'package:delivery_by_bike_users/assistantMethods/card_Item_counter.dart';
import 'package:delivery_by_bike_users/global/global.dart';
import 'package:delivery_by_bike_users/splashScreen/splashScreen.dart';
import 'package:delivery_by_bike_users/widgets/menus_card_design_widget.dart';
import 'package:delivery_by_bike_users/widgets/special_appbar.dart';
import 'package:delivery_by_bike_users/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CardItemCounter())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivery By Bike',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Color(0xffCAFB09)),
            color: Color(0xFF1F1F1F),
          ),
          primaryColor: const Color(0xffCAFB09),
          primaryColorDark: const Color(0xFF1F1F1F),
          primaryColorLight: const Color(0xFF393939),
          scaffoldBackgroundColor: const Color(0xFFF6F6F8),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xFFf5f5f5),
          ),
          fontFamily: 'SFProRegular',
        ),
        home: MySplashScreen (),
      ),
    );
  }
}
