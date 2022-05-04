import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<String?> settings() async{
    print(ApiUrl.BASE_URL + ApiUrl.Settings);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Settings),
    headers: <String,String>{
      'authorization' : basicAuth
    });
    try {
      var data = json.decode(response.body);
      print("Settingsdata: $data");

    }catch(Exception){
      FocusScope.of(context).requestFocus(new FocusNode());
      Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    settings();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
