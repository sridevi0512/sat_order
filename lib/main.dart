import 'package:flutter/material.dart';
import 'package:sat_order_app/addWidget.dart';
import 'package:sat_order_app/data/orderSuccess.dart';
import 'package:sat_order_app/homePage.dart';
import 'package:sat_order_app/orderDetail.dart';
import 'package:sat_order_app/splashScreenpage.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginMainPage.dart';

Future<void> main() async {
  runApp(const MyApp());
}
showLoaderDialog(BuildContext context){
  AlertDialog alert =AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child: Text("Loading.....")),
      ],
    ),
  );
  showDialog(barrierDismissible:false,context: context, builder: (BuildContext context){
    return alert;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAT App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  SplashScreenPage(),
    );
  }
}

