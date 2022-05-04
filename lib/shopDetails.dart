import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/shopProfile.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'data/detailsShop.dart';
import 'homePage.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({Key? key}) : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {

  int _radioSelected = 1;
  List<DetailsS> shopdetailsdata = [];
  bool isVisible = false;

  //all shops profile
  Future<String?> getAllShops() async{
    print(ApiUrl.BASE_URL + ApiUrl.Shops);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Shops),
      headers: <String,String> {'authorization' : basicAuth},);
    try {
      var data = json.decode(response.body);
      setState(() {
        shopdetailsdata = (data).map<DetailsS>((item) => DetailsS.fromJson(item)).toList();
        print("shopdetailsdata: $data");
      });

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
    super.initState();
    getAllShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: false,
        actions: <Widget>[
          IconButton(onPressed: (){},
            icon: Icon(Icons.help_center_outlined),
            iconSize: 25,
            color: Colors.grey.shade800,)
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: IconButton(
          onPressed: (){Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomePage())
          );
          },
          icon: Image.asset('images/back-arrow.png'),
          iconSize: 18,
          color: Colors.grey.shade800,
        ),
      ),
      body:Padding(
          padding:EdgeInsets.all(20),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Shop Details",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: shopdetailsdata.length,
                  separatorBuilder: (BuildContext context, int index)=>Divider(height: 1,color: Color(0xff757575)),
                  itemBuilder: (BuildContext context,int index){
                    return GestureDetector(
                      onTap: (){
                         Navigator.of(context)
                            .pushReplacement(
                          MaterialPageRoute(builder: (context) => ShopProfile(shop_id: shopdetailsdata[index].id.toString()))

                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shopdetailsdata[index].first_name!,
                                      style: TextStyle(
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      shopdetailsdata[index].address!,
                                      style: TextStyle(
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      shopdetailsdata[index].city!,
                                      style: TextStyle(
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white,
                                      disabledColor: Colors.white
                                  ),
                                  child: Radio<String>(
                                    value: shopdetailsdata[index].id.toString(),
                                    groupValue: _radioSelected.toString(),
                                    activeColor: Colors.blueAccent,
                                    onChanged: (value) {
                                      setState(() {
                                        _radioSelected = shopdetailsdata[index].id!;
                                      });
                                    },
                                  ),

                                )

                              ],

                            ),
                            SizedBox(height: 20),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text(
                                        "Name: ",
                                        style: TextStyle(
                                            color: Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18
                                        ),

                                      ),
                                      Text(
                                        shopdetailsdata[index].first_name! + shopdetailsdata[index].lastName!,
                                        style: TextStyle(
                                            color: Color(0xff757575),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18
                                        ),
                                      ),

                                    ],
                                  )
                                ]
                            ),
                            SizedBox(height: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text(
                                        "Mobile: ",
                                        style: TextStyle(
                                            color: Color(0xff757575),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18
                                        ),

                                      ),
                                      Text(
                                        shopdetailsdata[index].phone_number!,
                                        style: TextStyle(
                                            color: Color(0xff757575),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18
                                        ),
                                      ),

                                    ],
                                  ),
                                ]
                            )

                          ],
                        ),
                      ),
                    );
                  },
                ),
              )

            ],
          )
      ),
    );
  }

}
