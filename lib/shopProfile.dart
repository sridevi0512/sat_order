import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/homePage.dart';
import 'package:sat_order_app/shopDetails.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:sat_order_app/utils/constants.dart';

class ShopProfile extends StatefulWidget {
  String shop_id;
  ShopProfile({Key? key,required this.shop_id}) :
        super(key: key);

  @override
  _ShopProfileState createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile> {

  String first_name = '';
  String last_name = '';
  String shop_name = '';
  String address = '';
  String area = '', city = '';
  String phone_number = '';

  Future<String?> profileShop(String shop_id) async{
    print(ApiUrl.BASE_URL + ApiUrl.Shop_Profile+shop_id);

    String basicAuth = 'Basic ' + base64Encode(utf8.encode((Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD)));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL+ApiUrl.Shop_Profile+shop_id),
        headers: <String,String> {
          'authorization' : basicAuth
        },

    );
    try {
      var data = json.decode(response.body);
      print("data $data");
      if(data["id"] != null){
        print("success");
        shop_id = data['id'].toString();
        print("shop_id $shop_id");
        setState(() {
          first_name = data['first_name'].toString();
          last_name = data['last_name'].toString();
          shop_name = first_name +last_name;
          address = data['billing']['address_1'].toString();
          city = data['billing']['city'].toString();
          area = data['billing']['city'].toString();
          phone_number = data['billing']['phone'].toString();
        });
        print("first_name $shop_name");
        print("address $address");
        print("city $city");
        print("area $area");
        print("phone_number $phone_number");

      } else {
        Fluttertoast.showToast(
            msg: 'No Data Found',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }
    }catch(Exception){
      FocusScope.of(context).requestFocus(new FocusNode());
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    profileShop(this.widget.shop_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: false,
            actions: <Widget> [
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.help_center_outlined),
              iconSize: 25,
              color: Colors.grey.shade800,)
            ],

            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: IconButton(
              onPressed: (){
                Navigator.of(context).
                push(MaterialPageRoute(builder: (context) => ShopDetail()));
              },
              icon: Image.asset('images/back-arrow.png'),
              iconSize: 18,
              color: Colors.grey.shade800,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35),
                      Text(
                        "Shop Profile",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,

                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Shop Name",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),),
                      SizedBox(height: 10),
                      Text(
                        shop_name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 16
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Address Lane",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      SizedBox(height: 10),
                      Text(
                        address,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("City",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      SizedBox(height: 10),
                      Text(
                        city,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Area",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      SizedBox(height: 10),
                      Text(
                        area,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Phone Number",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      SizedBox(height: 10),
                      Text(
                        phone_number,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
