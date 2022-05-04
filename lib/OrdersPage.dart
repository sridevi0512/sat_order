import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/data/detailsOrder.dart';
import 'package:sat_order_app/specificOrderPage.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'homePage.dart';


class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<DetailsOrder> detailsOrder = [];

  Future<String?> getOrders() async {
    print(ApiUrl.BASE_URL + ApiUrl.Orders);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Orders),
    headers: <String,String>{
      'authorization' : basicAuth
    });
    try{
      var data = json.decode(response.body);
      print(data);
      setState(() {
        detailsOrder = (data).map<DetailsOrder>((item) => DetailsOrder.fromJson(item)).toList();
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
    getOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
                centerTitle: false,
                actions: <Widget>[

                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    IconButton(
                      onPressed: (){Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage())
                      );
                      },
                      icon: Image.asset('images/back-arrow.png'),
                      iconSize: 18,
                      color: Colors.grey.shade800,
                    ),
                    Text("Orders",
                      style: TextStyle(
                          color: Color(0xff757575)
                      ),)
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                  height: 10,
                ); },
                itemCount: detailsOrder.length,
                itemBuilder: (BuildContext context, int index){

                  return GestureDetector(
                    onTap: (){
                      Navigator.of(context)
                          .pushReplacement(
                        MaterialPageRoute(builder: (context) => SpecificOrderPage(orderId:detailsOrder[index].id.toString()))
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "OrderId: ",
                                    style: TextStyle(
                                        color: Color(0xff757575),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18
                                    ),

                                  ),
                                  Flexible(
                                    child: Text(
                                      detailsOrder[index].id.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff757575)
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  ('\u{20B9} ${detailsOrder[index].total_price.toString()}'),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff757575)
                                ),
                              )
                            ],
                          ),


                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "ShopName: ",
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),

                              ),
                              Flexible(
                                child: Text(
                                  detailsOrder[index].first_name.toString() + " " +  detailsOrder[index].lastName.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff757575)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "City: ",
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),

                              ),
                              Flexible(
                                child: Text(
                                  detailsOrder[index].city.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff757575)
                                  ),
                                ),
                              ),
                            ],
                          ),


                          SizedBox(height: 5),
                          Row(

                            children: [
                              Text(
                                "Email: ",
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),

                              ),
                              Flexible(
                                child: Text(
                                  detailsOrder[index].email.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff757575)
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(

                              children: [
                                Text(
                                  "Phone Number: ",
                                  style: TextStyle(
                                      color: Color(0xff757575),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                  ),

                                ),
                                Flexible(
                                  child: Text(
                                    detailsOrder[index].phone_number.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff757575)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),


                        ],

                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),

    );
  }
}
