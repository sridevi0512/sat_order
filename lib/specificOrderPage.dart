import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/OrdersPage.dart';
import 'package:sat_order_app/data/orderdt.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class SpecificOrderPage extends StatefulWidget {
  String orderId;
   SpecificOrderPage({Key? key,required this.orderId}) : super(key: key);

  @override
  _SpecificOrderPageState createState() => _SpecificOrderPageState();
}

class _SpecificOrderPageState extends State<SpecificOrderPage> {
  String first_name = '';
  String orderID = '';
  String last_name = '';
  String email = '', city = '';
  String phone_number = '';
  String total_price = '';
  String pending_amount = '';
  List<OrderDt> dt = [];

  Future<OrderDt?> profileShop(String order_id) async{
    print(ApiUrl.BASE_URL + ApiUrl.Orders_dt+order_id);

    String basicAuth = 'Basic ' + base64Encode(utf8.encode((Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD)));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL+ApiUrl.Orders_dt+order_id),
      headers: <String,String> {
        'authorization' : basicAuth
      },

    );
    try {
      var data = json.decode(response.body);
      print("data $data");
      if(data["id"] != null){
        print("success");
        orderID = data['id'].toString();
        print("orderID $orderID");
        setState(() {
          first_name = data['billing']['first_name'].toString();
          last_name = data['billing']['last_name'].toString();
          city = data['billing']['city'].toString();
          email = data['billing']['email'].toString();
          phone_number = data['billing']['phone'].toString();
          total_price = data['total'].toString();
          pending_amount = data['shipping_total'].toString();
          dt = (data['line_items'] as List)
              .map((p) => OrderDt.fromJson(p))
              .toList();
        });
        print("first_name $first_name");
        print("last_name $last_name");
        print("city $city");
        print("email $email");
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
    profileShop(this.widget.orderId);
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
          appBar: AppBar(
            centerTitle: false,
            actions: <Widget> [

            ],

            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: IconButton(
              onPressed: (){
                Navigator.of(context).
                push(MaterialPageRoute(builder: (context) => OrderPage()));
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
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order Details",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "OrderId : ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              orderID.toString(),
                              style: TextStyle(
                                color: Color(0xff757575),
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Name : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              first_name.toString() +" "+last_name.toString(),
                              style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "City : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              city.toString(),
                              style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Email : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              email.toString(),
                              style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Phone Number : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              phone_number.toString(),
                              style: TextStyle(
                                  color: Color(0xff757575),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),

                      Table(
                        children: [
                        TableRow(
                          children: [
                            Text(
                              "Product Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 18
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Quantity",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Price",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 18
                              ),
                            )
                          ],
                        ),
                ]
                      ),

                      SizedBox(height: 10),
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dt.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              child: Table(
                                children:[
                                  TableRow(
                                  children: [
                                    Padding(
                                      padding:EdgeInsets.only(top: 10,bottom: 10),
                                      child: Text(
                                        dt[index].name.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff757575)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Padding(
                                      padding:EdgeInsets.all(10),
                                      child: Text(
                                        dt[index].quantity.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff757575)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Padding(
                                      padding:EdgeInsets.all(10),
                                      child: Text(
                                        dt[index].total.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff757575)
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child:Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Net Amount ",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '\u{20B9} ${total_price}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                  child:Text(
                                    '(' + 'Pending Amount ' + '\u{20B9} ${pending_amount}' + ')',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  )
                                  ),


                            ],
                          )

                      )
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
