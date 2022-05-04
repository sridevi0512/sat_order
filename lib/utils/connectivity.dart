import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class ConnectivityState{
  bool isWifiConnected = false;
  bool isInternetOn = true;

  static final ConnectivityState connectivityState =
  ConnectivityState.internal();

  ConnectivityState.internal();
  factory ConnectivityState() => connectivityState;

  isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none){
      return false;
    } else {
      return true;
    }
  }

  static void showCustomDialog(BuildContext context, {required String title,
  String okBtnText = "Ok",
  String cancelBtnTxt = "Cancel",})
  {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text(okBtnText))
            ],
          );
        });
  }

}