import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:sat_order_app/utils/preference.dart';

import 'data/order.dart';
import 'data/orderSuccess.dart';
import 'data/productdtItam.dart';
import 'homePage.dart';

class OrderDetails extends StatefulWidget {
  String product_order_items;
  String line_items;
  String customer_id;
  String first_name;
  String last_name;
  String address_1;
  String address_2;
  String city;
  String state;
  String postcode;
  String country;
  String email;
  String number;
  String overall;
  String overallamnt;
  String pendingAmount;
  OrderDetails({Key? key,
    required this.product_order_items,
    required this.line_items,
    required this.customer_id,
    required this.first_name,
    required this.last_name,
    required this.address_1,
    required this.address_2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.email,
    required this.number,
    required this.overallamnt,
    required this.pendingAmount,
    required this.overall,}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<PdtItem> orderD = [];
  bool _isLoading = false;
  String order_id = '';
  var cat_name;
  var pdt_name;
  int CGST = 0;
  int SGST = 0;
  int totalPp = 0;
  int netTotal = 0;
  String customerEmail = '';
  var body;

  getData(){
    var data = json.decode(this.widget.product_order_items);
    orderD=  (data).map<PdtItem>((item) => PdtItem.toJson(item)).toList();

  }
  checkEmail(){
    if(this.widget.email!=''){

      customerEmail = this.widget.email.toString();
      print("CustomerEmail: ${customerEmail}");
    }
  }

  getTotal(){
    print("pending_amount: ${this.widget.pendingAmount}");
    netTotal = int.parse(this.widget.overall.toString());
    setState(() {
      totalPp = int.parse(this.widget.overallamnt.toString());
    });
  }

  //create an order
  Future<String?> createOrder(String line_items) async{
    print("line_items: $line_items");
    if(this.widget.email!=""){
       body = jsonEncode({
        "customer_id": this.widget.customer_id.toString(),
        "payment_method": "bacs",
        "payment_method_title": "Direct Bank Transfer",
        "set_paid": true,
        "billing": {
          "first_name": this.widget.first_name.toString(),
          "last_name": this.widget.last_name.toString(),
          "address_1": this.widget.address_1.toString(),
          "address_2": this.widget.address_2.toString(),
          "city": this.widget.city.toString(),
          "state": this.widget.state.toString(),
          "postcode": this.widget.postcode.toString(),
          "country": this.widget.country.toString(),
          "email": this.widget.email.toString(),
          "phone": this.widget.number.toString()

        },
        "shipping": {
          "first_name": this.widget.first_name.toString(),
          "last_name": this.widget.last_name.toString(),
          "address_1": this.widget.address_1.toString(),
          "address_2": this.widget.address_2.toString(),
          "city": this.widget.city.toString(),
          "state": this.widget.state.toString(),
          "postcode": this.widget.postcode.toString(),
          "country": this.widget.country.toString()
        },
        "line_items" : jsonDecode(line_items),
        "shipping_lines": [
          {
            "method_id": "flat_rate",
            "method_title": "Flat Rate",
            "total": this.widget.pendingAmount.toString(),
          }
        ]
      });
    }else{
      print(this.widget.pendingAmount.toString());
      body = jsonEncode({
        "customer_id": this.widget.customer_id.toString(),
        "payment_method": "bacs",
        "payment_method_title": "Direct Bank Transfer",
        "set_paid": true,
        "billing": {
          "first_name": this.widget.first_name.toString(),
          "last_name": this.widget.last_name.toString(),
          "address_1": this.widget.address_1.toString(),
          "address_2": this.widget.address_2.toString(),
          "city": this.widget.city.toString(),
          "state": this.widget.state.toString(),
          "postcode": this.widget.postcode.toString(),
          "country": this.widget.country.toString(),


        },
        "shipping": {
          "first_name": this.widget.first_name.toString(),
          "last_name": this.widget.last_name.toString(),
          "address_1": this.widget.address_1.toString(),
          "address_2": this.widget.address_2.toString(),
          "city": this.widget.city.toString(),
          "state": this.widget.state.toString(),
          "postcode": this.widget.postcode.toString(),
          "country": this.widget.country.toString()
        },
        "line_items" : jsonDecode(line_items),
        "shipping_lines": [
          {
            "method_id": "flat_rate",
            "method_title": "Flat Rate",
            "total": this.widget.pendingAmount.toString(),
          }
        ]
      });

    }


    print(ApiUrl.BASE_URL + ApiUrl.Orders);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);
    print("body: $body");

    final response = await http.post(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Orders),
      headers: <String,String> {
        "Content-Type": "application/json",
        'authorization' : basicAuth
      },
      body: body,
    );
    try {
      var data = json.decode(response.body);
      print("data $data");
      if(data["id"] != null){
        print("order success");
        order_id = data['id'].toString();
        print("order_id $order_id");
        Preference.setOrderId(Constants.ORDER_ID, order_id);
        _isLoading = false;
        Fluttertoast.showToast(
            msg: "Order Created Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OrderSuccess()));

      } else {
        _isLoading = false;
        Fluttertoast.showToast(
            msg: 'Error',
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
    getData();
    getTotal();
    checkEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
            title: Row(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.of(context).
                    push(MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  icon: Image.asset('images/back-arrow.png'),
                  iconSize: 18,
                  color: Colors.grey.shade800,
                ),
                Text(
                  "Order Details",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 25,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),

          ),
          body:
          SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        child: ListView.builder(
                          itemCount: orderD.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index){
                            if(orderD[index].productName!.split("/").length>1){
                              cat_name = orderD[index].productName!.substring(orderD[index].productName!.lastIndexOf("/") + 1);
                              pdt_name = orderD[index].productName!.substring(0,orderD[index].productName!.lastIndexOf('/'));
                            }
                            return Container(
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // (pdt_name.length>10)?
                                    /*Expanded(
                                      child: Padding(
                                        padding:EdgeInsets.all(20),
                                        child: RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: pdt_name.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,

                                            ),

                                            children: <TextSpan>[
                                              TextSpan(
                                                text: " ",
                                                style:TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              TextSpan(text: "(" + cat_name +")",
                                                style:TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      flex: 3,
                                    ):*/
                                    Expanded(
                                      child: Padding(
                                        padding:EdgeInsets.all(20),
                                        child: RichText(
                                          text: TextSpan(
                                            text: pdt_name.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,

                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: " ",
                                                style:TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              TextSpan(text: "(" + cat_name +")",
                                                style:TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:EdgeInsets.only(left: 8,right: 8,top: 20,bottom: 20),
                                          child:Text(
                                              orderD[index].productQuantity.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18
                                            ),
                                          )
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding:EdgeInsets.only(top: 20,bottom: 20,left: 8,right: 8),
                                          child:Text(
                                              orderD[index].productPrice.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18
                                            ),
                                          )
                                      ),
                                    ),

                                  ],
                                )
                            );
                          },

                        ),
                      ),

                      SizedBox(height: 20),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                          child:Padding(
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
                                        '\u{20B9} ${this.widget.overall}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "CGST ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\u{20B9} ${CGST.toString()}',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SGST ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\u{20B9} ${SGST.toString()}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  (this.widget.pendingAmount !=0)?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Pending Amount ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\u{20B9} ${this.widget.pendingAmount.toString()}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  ):
                                      Container(),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '\u{20B9} ${totalPp.toString()}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )

                          )
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child:Center(
                              child:ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xffC61D1C),
                                      minimumSize: Size.fromHeight(50),
                                      shadowColor: Colors.black26
                                  ),
                                  onPressed: () {
                                    createOrder(this.widget.line_items);
                                  },

                                  child: Text(
                                    "Place Order",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white
                                    ),
                                  ))
                          )
                      )
                    ]
                ),
              ),
            ),
          ),
        )
    );

  }

}





