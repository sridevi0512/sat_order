import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sat_order_app/homePage.dart';
import 'package:sat_order_app/loginMainPage.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  startTime() {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration,navigationPage);
  }
  navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_name = prefs.getString(Constants.USER_NAME);
    print("user_name: ${user_name}");
    Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (context) => (user_name==null)?LoginMainPage():HomePage()));
  }
  @override
  void initState() {
    // TODO: implement initState
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff586FB0),
              Color(0xff566EAE),
              Color(0xff5687B9)
            ]
          )
        ),
        child: (
          new Center(
              child:Image.asset('images/sat-logo.png',
                  fit: BoxFit.cover)
          )
    )
      ),
    );
  }
}
