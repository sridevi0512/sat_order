import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sat_order_app/OrdersPage.dart';
import 'package:sat_order_app/createshop.dart';
import 'package:sat_order_app/data/dataList.dart';
import 'package:sat_order_app/data/productCategory.dart';
import 'package:sat_order_app/data/shopMetaData.dart';
import 'package:sat_order_app/data/shopName.dart';
import 'package:sat_order_app/orderDetail.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:sat_order_app/utils/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/order.dart';
import 'data/productName.dart';
import 'loginMainPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String currentTime = '';
  String userName = "", selectLine = '', select_Shops = '', selectDay = '';
  String? dropDownLineValue;
  String? dropDownDayValue;
  String? dropDownShopValue;
  int pending_amount = 0;
  int send_pending_balance = 0;
  List<ShopName> _shopName = [];
  List<ShopName> _daysName = [];
  List<ProductCategory> _category = [];
  List<ShopMetaData> _metaData = [];

  List<List<int>> QuantityListItem = [];
  List<List<int>> priceListItem = [];
  List<List<int>> productListItem = [];

  List<int> overallQuantity = [];
  List<int> overallPrice = [];
  List<int> overallProductItem = [];
  List<String> overallProductNameItem = [];
  List<double> totalpriceListItem = [];

  List<String> costListItem = [];
  List<DataList> overallList = [];


  List<List<TextEditingController>> quantitycontrollerMain = [];
  // List<List<TextEditingController>> pricecontrollerMain = [];
  List<List<int>> pricecontrollerMain = [];
  List<List<int>> costcontrollerMain = [];
  List<List<String>> productNameListMain = [];
  List<List<int>> dropListMain = [];
  List<List<String>> product_price = [];
  List<List<ProductName>> dropdownNameValue = [];


  List<int> shopitems = [];
  bool check = false;
  List<int> totalSum = [];
  List<String> priceMain = [];
  String? selectItem;
  List<bool>? _isChecked;
  var category_name;
  int overall =0;
  int CGST = 0;
  int SGST = 0;
  int totalPp = 0;
  int include_bal_amnt = 0;
  bool _isLoading = false;
  bool _isVisible = false;
  bool _isVisibleBal = false;

  String customer_id = '';
  String first_name = '';
  String last_name = '';
  String shop_name = '';
  String address1 = '';
  String address2 = '';
  String area = '', city = '', state = '', postcode = '', country = '';
  String phone_number = '';
  String email = '';
  String order_id = '';
  String pdt_id = '';
  int overall_amnt = 0;
  var days;
  // List<String> dayItems = [];


  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, total);
  }


//shops dropdown item
  Future<String?> selectShops() async{
    print(ApiUrl.BASE_URL + ApiUrl.Shops);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Shops),
      headers: <String,String> {'authorization' : basicAuth},);
    try {
      var data = json.decode(response.body);
      print("ShopDetails: ${data}");
      _shopName = (data).map<ShopName>((item) => ShopName.fromJson(item)).toList();
      // print(_shopName.length);
      List<ShopName> name = [];
      for(int i=0;i<_shopName.length;i++){
        if(_shopName[i].linelist![2].value!.toLowerCase() == selectLine.toLowerCase() && _shopName[i].linelist![4].value!.toLowerCase() == selectDay.toLowerCase()){
          name.add(_shopName[i]);

        }
      }

      setState(() {
        _shopName.clear();
        _shopName = name;
      });
    }catch(Exception){
      FocusScope.of(context).requestFocus(new FocusNode());
      Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }



  //days dropdown item
  Future<String?> getDays() async{
    print(ApiUrl.BASE_URL + ApiUrl.Shops);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Shops),
      headers: <String,String> {'authorization' : basicAuth},);
    try {
      var data = json.decode(response.body);
      print("ShopDetails: ${data}");
      _daysName = (data).map<ShopName>((item) => ShopName.fromJson(item)).toList();
      // print(_shopName.length);
      for(int i=0;i<_daysName.length;i++){
        print(_daysName[i].linelist![4].value);
          print("shop value true");
          // dayItems.add(_daysName[i].linelist![4].value!);

      }
    }catch(Exception){
      FocusScope.of(context).requestFocus(new FocusNode());
      Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }


  //retrieve shops detail by shop id
  Future<String?> ShopDetails(String shop_id) async{
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
        setState(() {
          customer_id = data['id'].toString();
          first_name = data['first_name'].toString();
          last_name = data['last_name'].toString();
          shop_name = first_name +last_name;
          address1 = data['billing']['address_1'].toString();
          address2 = data['billing']['address_2'].toString();
          city = data['billing']['city'].toString();
          state = data['billing']['state'].toString();
          postcode = data['billing']['postcode'].toString();
          country = data['billing']['country'].toString();
          email = data['email'].toString();
          phone_number = data['billing']['phone'].toString();
          _metaData = (data['meta_data']).map<ShopMetaData>((item) => ShopMetaData.fromJson(item)).toList();
        });
        print("shop_id $customer_id");
        print("first_name $first_name");
        print("last_name $last_name");
        print("address1 $address1");
        print("address2 $address2");
        print("city $city");
        print("state $state");
        print("postcode $postcode");
        print("country $country");
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


  // product category
  Future<String?> selectProductCategories() async{
    print(ApiUrl.BASE_URL + ApiUrl.Product_Category);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);

    final response = await http.get(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Product_Category),
      headers: <String,String> {'authorization' : basicAuth},);
    try {
      var data = json.decode(response.body);
      print("ProductCategories $data");
      setState(() {
        _category = (data).map<ProductCategory>((item) => ProductCategory.fromJson(item)).toList();
        _isChecked = List<bool>.filled(_category.length, false);
      });


    }catch(Exception){
      FocusScope.of(context).requestFocus(new FocusNode());
      Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT);
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _dropdownDaykey = new GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _dropdownShopKey = new GlobalKey<FormFieldState>();

  List<String> lineItems = [
    'A',
    'B',
    'C'
  ];
  List<String> dayItems = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'];
//add list item
  addItems(int i) {
    setState(() {
      shopitems[i] = shopitems[i]+1 ;
    });
  }
  total(){
    if (mounted) {
      setState(() {
        overall = overall;
        totalPp = totalPp;
        include_bal_amnt = include_bal_amnt;
      });
      // print("overall: $overall");
    }
  }

  get_userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     userName = prefs.getString(Constants.USER_NAME)!;
    print("user_name: ${userName}");
  }

  getCurrentTime(){
    setState(() {
      currentTime = DateFormat.jm().format(DateTime.now());

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
    get_userName();
    getCurrentTime();
    selectProductCategories();
    getDays();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer:
          Drawer(

            //side navigation bar
            child: Center(
              child:ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [

                  ListTile(
                    title: Center(
                        child:Text(
                          "Home",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w600),)),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Center(
                        child:Text('New Order',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          ),)
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },

                  ),
                  ListTile(
                    title: Center(child:Text('My Order',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),)),
                    onTap: (){
                      Navigator.of(context)
                          .pushReplacement(
                          MaterialPageRoute(builder: (context) => OrderPage())
                      );
                    },
                  ),
                  ListTile(
                    title: Center(child:Text('Add Shop',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.grey[600]
                      ),)
                    ),
                    onTap: () {
                      Navigator.of(context).
                      pushReplacement(
                          MaterialPageRoute(builder: (context)=> CreateShop())
                      );
                    },
                  ),
                  ListTile(
                    title: Center(
                        child: Text('Settings',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600]
                          ),
                        )
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                      /* Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => ShopDetail()));*/
                    },
                  ),
                  ListTile(
                    title: Center(
                        child:Text('Logout',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                              fontSize: 18
                          ),)),
                    onTap: () async {
                      // Navigator.pop(context);
                      SharedPreferences preference = await SharedPreferences.getInstance();
                      preference.remove(Constants.USER_NAME);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:(BuildContext ctx) => LoginMainPage()
                          ));
                    },
                  ),
                  ListTile(
                    title: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: (){Navigator.pop(context);},
                          icon:Icon(Icons.cancel_outlined,
                            size: 25,
                            color: Colors.grey[600],
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          body:
          Form(
            key: _key,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed:(){
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            icon:Icon(Icons.sort),
                            color: Colors.grey[500],
                            iconSize: 30,
                          ),
                          Spacer(),
                          Column(
                            children:[
                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 20),
                                child:Text(
                                  "Welcome $userName!",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10,right: 20),
                                child: Text(
                                  currentTime.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children:[
                              SizedBox(
                                height: 20.0,
                              ),

                              //select line
                              Flexible(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: /*Color.fromRGBO(0, 0, 0, 0.25)*/Colors.grey.shade300,
                                            spreadRadius: 0.0,
                                            blurRadius: 3,
                                            offset: Offset(3.0,3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 0.0,
                                            blurRadius: 3/2,
                                            offset: Offset(3.0,3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2.0,
                                            blurRadius: 3,
                                            offset: Offset(-3.0,-3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2.0,
                                            blurRadius: 3/2,
                                            offset: Offset(-3.0,-3.0)
                                        )
                                      ]
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(left:20,right: 20),

                                      child:DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)
                                            ),
                                            errorBorder:UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)
                                            ), ),
                                          hint: Text(
                                            'Select Line',
                                            style:
                                            TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.grey[600]),),
                                          icon: Image.asset('images/downarrow.png'),
                                          items: lineItems.map((e) {
                                            return DropdownMenuItem(
                                                value: e,
                                                child: Container(
                                                  child:Text(e,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 17,
                                                        color: Colors.grey[600]
                                                    ) ,),
                                                )
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              dropDownLineValue = newValue!;
                                              selectLine = dropDownLineValue!;
                                              print("selectLine $selectLine");
                                              print("DaySlt:$selectDay");
                                              if(selectDay!=''){
                                                _dropdownDaykey.currentState!.reset();
                                              }
                                            });
                                          },
                                          validator: (value) => value == null
                                              ? 'Please  Select Line': null
                                      )
                                  ),
                                ),
                              ),

                              //select day
                              SizedBox(width: 10),
                              Flexible(
                                child:DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: /*Color.fromRGBO(0, 0, 0, 0.25)*/ Colors.grey.shade300,
                                            spreadRadius: 0.0,
                                            blurRadius: 3,
                                            offset: Offset(3.0,3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.grey.shade400,
                                            spreadRadius: 0.0,
                                            blurRadius: 3/2,
                                            offset: Offset(3.0,3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2.0,
                                            blurRadius: 3,
                                            offset: Offset(-3.0,-3.0)
                                        ),
                                        BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2,
                                            blurRadius: 3/2,
                                            offset: Offset(-3.0,-3.0)
                                        )
                                      ]
                                  ),
                                  child:Padding(
                                      padding: EdgeInsets.only(left: 20,right: 20),
                                      child:DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)),
                                            focusedBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)
                                            ),
                                            errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(color: Colors.white)
                                            )),
                                        hint:  Text(
                                            'Select Day',
                                            style:
                                            TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.grey[600])),
                                        icon: Image.asset('images/downarrow.png'),
                                        items: dayItems.map((items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[600]
                                              ),),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropDownDayValue = value!;
                                            selectDay = dropDownDayValue!;
                                            print("selectDay $selectDay");
                                            selectShops();
                                            print(select_Shops);
                                            if(select_Shops!=''){
                                              _dropdownShopKey.currentState!.reset();
                                            }


                                          });

                                        },
                                        key: _dropdownDaykey,
                                        validator: (value) => value == null
                                            ? 'Please  Select Day': null,
                                      )
                                  ),
                                ),
                              )
                            ],
                          )
                      ),

                      //select shop
                      Flexible(
                          child:Padding(
                            padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                            child:DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: /*Color.fromRGBO(0, 0, 0, 0.25)*/ Colors.grey.shade300,
                                        spreadRadius: 0.0,
                                        blurRadius: 3,
                                        offset: Offset(3.0,3.0)
                                    ),
                                    BoxShadow(
                                        color: Colors.grey.shade400,
                                        spreadRadius: 0.0,
                                        blurRadius: 3/2,
                                        offset: Offset(3.0,3.0)
                                    ),
                                    BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 2.0,
                                        blurRadius: 3,
                                        offset: Offset(-3.0,-3.0)
                                    ),
                                    BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 2.0,
                                        blurRadius: 3/2,
                                        offset: Offset(-3.0,-3.0)
                                    )
                                  ]
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 20,right: 20),

                                child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    icon: Image.asset("images/downarrow.png"),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white)
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white)
                                        )),
                                    hint:  Center(
                                        child:Text('Select Shops',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.grey[600]))),
                                    items: _shopName.map((ShopName items) {
                                      return DropdownMenuItem<String>(
                                          value: items.id.toString(),
                                          child: Center(
                                            child:Text(items.shopName!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17
                                              ),
                                            ),
                                          )
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _isVisible = true;
                                        select_Shops = value!;
                                        print("selectShop $select_Shops");
                                        ShopDetails(select_Shops);

                                      });
                                    },
                                    key:_dropdownShopKey,
                                    validator: (value) => value == null
                                        ? 'Please Select Shop': null
                                ),


                              ),
                            ),
                          )
                      ),
                      SizedBox(height: 10),

                      ListView.builder(
                        itemCount: _metaData.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index){
                          if(_metaData[index].meta_data_key_value=="balance_amount"){
                            pending_amount= int.parse(_metaData[index].meta_data_balance_amnt.toString());
                            _isVisibleBal = true;
                          }


                          return (_metaData[index].meta_data_key_value=="balance_amount")?
                           Visibility(
                            visible: _isVisible,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Pending Balance: ',
                                    style: TextStyle(
                                        color: Color(0xff757575),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '\u{20B9} ${_metaData[index].meta_data_balance_amnt}',
                                        style:TextStyle(
                                            color: Color(0xff757575),
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ):
                              Container();

                        },
                      ),

                      SizedBox(height: 20),

                      //Category
                      Padding(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child:Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _category.length,
                              itemBuilder: (BuildContext context,int mainIndex){
                                List<TextEditingController> quantityControllerInner = [];
                                // List<TextEditingController> priceControllerInner = [];
                                 List<int> priceControllerInner = [];
                                List<int> droplistInner = [];
                                List<int> costControllerInner = [];
                                List<String> productNameListInner = [];

                                List<int> QuantityInner = [];
                                List<int> PriceInner = [];
                                List<int> ProductInner = [];

                                List<ProductName> dropdownlist = [];
                                dropdownNameValue.add(dropdownlist);
                                shopitems.add(1);
                                quantitycontrollerMain.add(quantityControllerInner);
                                dropListMain.add(droplistInner);
                                pricecontrollerMain.add(priceControllerInner);
                                productNameListMain.add(productNameListInner);
                                costcontrollerMain.add(costControllerInner);
                                QuantityListItem.add(QuantityInner);
                                productListItem.add(ProductInner);
                                priceListItem.add(PriceInner);


                                //total amount
                                int cs = 0;
                                for(int i =0; i<costcontrollerMain.length;i++){
                                  for(int j=0; j<costcontrollerMain[i].length;j++){
                                    cs = costcontrollerMain[i][j] + cs;

                                  }
                                }


                                return new Row(
                                  children:[
                                    //category
                                    Expanded(
                                      child: ExpansionTile(

                                          trailing:SizedBox.shrink(),
                                          leading: Icon(
                                            _isChecked![mainIndex]
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank_outlined,
                                          ),
                                          onExpansionChanged: (bool isExpanded) async {
                                            print("category_id ${_category[mainIndex].category_id}");
                                            print("category_name ${_category[mainIndex].category_name}");
                                            var category_id = _category[mainIndex].category_id;

                                            //clear values in listview
                                            for(int i=0; i<quantitycontrollerMain[mainIndex].length;i++){
                                              quantitycontrollerMain[mainIndex][i].text = '';
                                              pricecontrollerMain[mainIndex][i] = 0;
                                              costcontrollerMain[mainIndex][i] = 0;
                                              dropListMain[mainIndex][i] = 0;
                                              totalPp = 0;
                                              overall = 0;
                                              include_bal_amnt = 0;

                                            }

                                            print(ApiUrl.BASE_URL + ApiUrl.Product);
                                            String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
                                            print(basicAuth);
                                            final queryParameters = {
                                              'category': category_id,
                                            }.map((key, value) => MapEntry(key, value.toString()));

                                            var url = Uri.parse(ApiUrl.BASE_URL + ApiUrl.Product);
                                            final newURI = url.replace(queryParameters: queryParameters);
                                            print(newURI);
                                            var response = await http.get(newURI, headers: {
                                              'Authorization': basicAuth,

                                            });
                                            try{
                                              var data = json.decode(response.body);
                                              dropdownNameValue[mainIndex].clear();
                                              print(data);
                                              setState(() {
                                                dropdownNameValue[mainIndex] = (data).map<ProductName>((item) => ProductName.fromJson(item)).toList();
                                              });

                                            }catch(Exception){
                                              FocusScope.of(context).requestFocus(new FocusNode());
                                              Fluttertoast.showToast(msg: "The Server is temporarily unable to service your request",
                                                  gravity: ToastGravity.BOTTOM,
                                                  toastLength: Toast.LENGTH_SHORT);
                                            }



                                            setState(() {
                                              _isChecked![mainIndex] = isExpanded;
                                            });

                                          },

                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children:[
                                                Padding(padding:
                                                EdgeInsets.all(10),
                                                    child:Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Item",
                                                          style: TextStyle(
                                                              color: Color(0xff767676),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),

                                                        Text(
                                                          "Quantity",
                                                          style: TextStyle(
                                                              color: Color(0xff767676),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Price",
                                                          style: TextStyle(
                                                              color: Color(0xff767676),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Cost",
                                                          style: TextStyle(
                                                              color: Color(0xff767676),
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                                //Add and remove  product items in list
                                                Flexible(
                                                  child: ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: shopitems[mainIndex],
                                                    shrinkWrap: true,
                                                    itemBuilder: (BuildContext context, int innerIndex) {
                                                      quantitycontrollerMain[mainIndex].add(new TextEditingController());
                                                      // pricecontrollerMain[mainIndex].add(new TextEditingController());
                                                      pricecontrollerMain[mainIndex].add(0);
                                                      productNameListMain[mainIndex].add('');
                                                      costcontrollerMain[mainIndex].add(0);
                                                      dropListMain[mainIndex].add(0);


                                                      QuantityListItem[mainIndex].add(0);
                                                      priceListItem[mainIndex].add(0);
                                                      productListItem[mainIndex].add(0);
                                                      totalpriceListItem.add(0.0);

                                                      //total cost
                                                      if(quantitycontrollerMain[mainIndex][innerIndex].text != '' && pricecontrollerMain[mainIndex][innerIndex] != ''){
                                                        totalSum.add(
                                                            (int.parse(quantitycontrollerMain[mainIndex][innerIndex].text)) * pricecontrollerMain[mainIndex][innerIndex]);

                                                        costcontrollerMain[mainIndex][innerIndex] =  totalSum.last;
                                                        overall = cs;
                                                        totalPp = overall + (overall*(SGST+CGST));
                                                        include_bal_amnt = totalPp+ pending_amount;
                                                        startTime();


                                                      }

                                                      // append value for cost controller
                                                      return Padding(
                                                        padding: EdgeInsets.only(bottom: 10),
                                                        child: Container(
                                                          child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  // mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width *0.3,
                                                                       height: 60,
                                                                      child:DropdownButtonFormField<ProductName>(
                                                                        isExpanded: true,
                                                                        menuMaxHeight: 300,
                                                                        decoration: const InputDecoration(
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey,
                                                                                width: 1.0),
                                                                          ),
                                                                          border: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey,
                                                                                width: 1.0),
                                                                          ),
                                                                          errorStyle: TextStyle(height: 0),
                                                                          errorBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 1.0),
                                                                          ),
                                                                        ),

                                                                        hint:  Center(
                                                                            child:Text('Select',
                                                                                style: TextStyle(
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 16,
                                                                                    color: Colors.grey[600]))),

                                                                        items: dropdownNameValue[mainIndex]
                                                                            .map((ProductName selectlist) {
                                                                          return DropdownMenuItem<ProductName>(
                                                                            value: selectlist,
                                                                            child: Text(selectlist.product_name.toString(),
                                                                                style: TextStyle(
                                                                                    color: Colors.grey,
                                                                                    fontSize: 18)),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged: (ProductName? newvalue){
                                                                          setState(() {
                                                                            print(newvalue!.product_id.toString());
                                                                            selectItem = newvalue.product_id.toString();
                                                                            pricecontrollerMain[mainIndex][innerIndex] = (newvalue.product_price == "")?int.parse("0"):int.parse(newvalue.product_price!);
                                                                          });

                                                                        },
                                                                        onSaved: (ProductName? value){
                                                                          setState(() {
                                                                            if(value != null){
                                                                              dropListMain[mainIndex][innerIndex] = int.parse(value.product_id.toString());
                                                                              productNameListMain[mainIndex][innerIndex] = (value.product_name.toString() + "/" + (_category[mainIndex].category_name.toString()));
                                                                            }

                                                                            // dropList[mainIndex] = value;
                                                                          });

                                                                        },
                                                                        validator: (value){
                                                                          if(value==null){
                                                                            Fluttertoast.showToast(msg: 'Please select Items',
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM);
                                                                            return '';
                                                                          }

                                                                        },

                                                                        // value: this.dropList[index].toString(),

                                                                      ),
                                                                    ),

                                                                    SizedBox(width: 5),
                                                                    Flexible(child:
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width *0.3,
                                                                      height: 60,
                                                                      child:TextFormField(
                                                                        // autofocus: true,
                                                                        onChanged: (value){
                                                                          setState(() {
                                                                            // startTime();
                                                                          });
                                                                        },
                                                                        controller: quantitycontrollerMain[mainIndex][innerIndex],
                                                                        keyboardType: TextInputType.number,
                                                                        decoration: const InputDecoration(
                                                                          enabledBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey,
                                                                                width: 1.0),
                                                                          ),

                                                                          border: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.grey,
                                                                                width: 1.0),
                                                                          ),
                                                                          errorBorder: OutlineInputBorder(
                                                                            borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 1.0),),
                                                                          hintText: "Quantity",
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 14),
                                                                          errorStyle: TextStyle(height: 0),),
                                                                        validator: (value){
                                                                          if(value!.isEmpty){
                                                                            Fluttertoast.showToast(msg: 'Please Enter Quantity',
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM);
                                                                            return '';
                                                                          }
                                                                          return null;

                                                                        },

                                                                      ),
                                                                    ),
                                                                    ),
                                                                    SizedBox(width: 5),
                                                                    Flexible(child:
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.2,
                                                                      height: 60,
                                                                      decoration:  BoxDecoration(
                                                                          border: Border.all(color: Colors.grey, width:1.0),
                                                                          borderRadius: BorderRadius.circular(5)
                                                                      ),
                                                                      child:Center(
                                                                        child:Text(
                                                                          pricecontrollerMain[mainIndex][innerIndex].toString(),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ),
                                                                    SizedBox(width: 5),
                                                                    Flexible(child:
                                                                    Container(
                                                                      child:Text(
                                                                        'Rs. '+ costcontrollerMain[mainIndex][innerIndex].toString(),
                                                                      ),
                                                                    ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Container(
                                                                      width: 20,
                                                                      height: 20,
                                                                      child: GestureDetector(
                                                                        onTap: (){
                                                                          setState(() {
                                                                            dropListMain[mainIndex].removeAt(innerIndex);
                                                                            quantitycontrollerMain[mainIndex].removeAt(innerIndex);
                                                                            pricecontrollerMain[mainIndex].removeAt(innerIndex);
                                                                            shopitems[mainIndex] = shopitems[mainIndex]-1;
                                                                          });
                                                                        },
                                                                        child: Image.asset(
                                                                            "images/minus.png"
                                                                        ),
                                                                      ),


                                                                    ),

                                                                  ],
                                                                ),
                                                              ]


                                                          ),
                                                        ),
                                                      );

                                                    },
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color(0xffd8d2d2),),
                                                  onPressed: (){addItems(mainIndex);},
                                                  child: Text("Add Product",
                                                    style: TextStyle(
                                                      color: Color(0xffc31d1c),
                                                    ),),
                                                ),
                                              ],
                                            ),

                                          ],

                                          title:Row(children:[
                                            Text(_category[mainIndex].category_name!,)
                                          ])

                                      ),

                                    )

                                  ],
                                );
                              },
                            ),
                          )
                      ),


                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.only(left: 20,right: 20,top: 10),
                          child:Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        blurRadius: 5,
                                        color: Color.fromRGBO(0, 0, 0, 0.25)
                                    )
                                  ]
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                        child:Text(
                                          "Total",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600]
                                          ),
                                        )
                                    ),

                                     Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Net   Rs. ",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(width: 18),
                                              Text(
                                                "${overall}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "CGST Rs. ",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                CGST.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 16,
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
                                                "SGST Rs. ",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                SGST.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total Rs. ",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                "${totalPp}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Visibility(
                                            visible: _isVisibleBal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Include Balance. ",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 18
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "${include_bal_amnt}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),

                                              ],
                                            ),
                                          )

                                        ],
                                      ),

                                  ],

                                ),
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

                                    overall_amnt = (_isVisibleBal==true)? include_bal_amnt:totalPp;
                                    print("overall_Amount: $overall_amnt");
                                    send_pending_balance = (_isVisibleBal==true)?pending_amount:0;
                                    print("send_pending_balance:${send_pending_balance}");
                                    _key.currentState!.save();


                                    if(_key.currentState!.validate()){
                                      if (overallQuantity.isNotEmpty ||
                                          overallPrice.isNotEmpty ||
                                          overallProductItem.isNotEmpty ||
                                          overallProductNameItem.isNotEmpty) {
                                        overallQuantity.clear();
                                        overallPrice.clear();
                                        overallProductItem.clear();
                                        overallProductNameItem.clear();
                                      }
                                      //overall quantity
                                      for (int i = 0; i < quantitycontrollerMain.length; i++) {
                                        for (int j = 0; j < quantitycontrollerMain[i].length; j++) {
                                          print(
                                              "QualityListItem: ${quantitycontrollerMain[i][j]
                                                  .text}");
                                          if (quantitycontrollerMain[i][j].text != '') {
                                            print(
                                                "QualityListItem: ${quantitycontrollerMain[i][j]
                                                    .text}");
                                            overallQuantity.add(int.parse(
                                                quantitycontrollerMain[i][j].text));
                                          }
                                        }
                                      }

                                      //overall price
                                      for (int i = 0; i < pricecontrollerMain.length; i++) {
                                        for (int j = 0; j < pricecontrollerMain[i].length; j++) {
                                          print(
                                              "PriceListItem: ${pricecontrollerMain[i][j]}");
                                          if (pricecontrollerMain[i][j] != 0) {
                                            print(
                                                "PriceListItem: ${pricecontrollerMain[i][j]}");
                                            overallPrice.add(pricecontrollerMain[i][j]);
                                          }
                                        }
                                      }

                                      //overall productId
                                      for (int i = 0; i < dropListMain.length; i++) {
                                        for (int j = 0; j < dropListMain[i].length; j++) {
                                          if (dropListMain[i][j] != 0) {
                                            print(
                                                "ProductListItem: ${dropListMain[i][j]}");
                                            overallProductItem.add(dropListMain[i][j]);

                                          }
                                        }
                                      }//overall productname
                                      for (int i = 0; i < productNameListMain.length; i++) {
                                        for (int j = 0; j < productNameListMain[i].length; j++) {
                                          if (productNameListMain[i][j] != '') {
                                            print(
                                                "ProductNameListItem: ${productNameListMain[i][j]}");
                                            overallProductNameItem.add(productNameListMain[i][j]);

                                          }
                                        }
                                      }

                                      print("overallQuantity: ${overallQuantity}");
                                      print("overallPrice: ${overallPrice}");
                                      print("overallProductName: ${overallProductNameItem}");
                                      print("overallProduct: ${overallProductItem}");

                                      //list of product_name and quantity
                                      final Order productOrderlist =
                                      Order(list_order: List<Product_Order>.generate(overallQuantity.length, (index) {
                                        return Product_Order(
                                          productName: overallProductNameItem[index].toString(),
                                          productQuantity: overallQuantity[index].toString(),
                                          productPrice: overallPrice[index].toString(),
                                        );
                                      }), );
                                      final String productOrderIt = json.encode(productOrderlist);
                                      print("productOrderIt: ${productOrderIt}");

                                      //list of productId and Quantity
                                      final DataList datalist =
                                      DataList(list: List<ListOrder>.generate(overallQuantity.length, (index) {
                                        return ListOrder(
                                          productId: overallProductItem[index].toString(),
                                          quantity: overallQuantity[index].toString(),
                                          sale_price: overallPrice[index].toString(),
                                        );
                                      }));
                                      final String line_items = json.encode(datalist);
                                      print("body: ${line_items}");
                                      Navigator.of(context).
                                      pushReplacement(
                                          MaterialPageRoute(builder: (context) =>
                                              OrderDetails(
                                                  product_order_items: productOrderIt,
                                                  line_items: line_items,
                                                  customer_id:customer_id.toString(),
                                                  first_name:first_name.toString(),
                                                  last_name: last_name.toString(),
                                                  address_1:address1.toString(),
                                                  address_2:address2.toString(),
                                                  city: city.toString(),
                                                  state:state.toString(),
                                                  postcode:postcode.toString(),
                                                  country:country.toString(),
                                                  email:email.toString(),
                                                  number: phone_number.toString(),
                                                  overallamnt:overall_amnt.toString(),
                                                  pendingAmount: send_pending_balance.toString(),
                                                  overall: overall.toString())));


                                    }

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
                )
            ),
          ),
        )
    );

  }


}
