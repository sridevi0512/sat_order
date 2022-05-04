import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/addShopSuccess.dart';
import 'package:sat_order_app/homePage.dart';
import 'package:sat_order_app/shopProfile.dart';
import 'package:http/http.dart'as http;
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/connectivity.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:sat_order_app/utils/preference.dart';

class CreateShop extends StatefulWidget {
  const CreateShop({Key? key}) : super(key: key);

  @override
  _CreateShopState createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
  TextEditingController shopnameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  bool _isLoading = false;
  FocusNode? _focusNode;
  bool _validate = false;

  String firstName = '';
  String lastName = '';
  String shop_id = '';
  var email, userName;
  int? randomNumber;


  var _formKey = GlobalKey<FormState>();

  //generate password
  String generatePassword({
    bool hasLetters = true,
    bool hasNumbers = true,
  }){
    final length = 7;
    final letterUpperCase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final letterLowerCase = 'abcdefghijklmnopqrstuvwxyz';
    final number = '0123456789';
    String char = '';
    if(hasLetters) char += '$letterUpperCase$letterLowerCase';
    if(hasNumbers) char += '$number';

    return List.generate(length, (index) {
      final indexrandom = Random.secure().nextInt(char.length);

      return char[indexrandom];
    }).join('');

  }

  Future<String?> createShop(String firstName,String lastName,String email,String userName) async{
    print(ApiUrl.BASE_URL + ApiUrl.Create_Shops);
    print("first_name: ${firstName.toString()}");
    print("last_name: ${lastName.toString()}");
    print("email: ${email.toString()}");
    print("username: ${userName.toString()}");
    lastName = (lastName.toString() == ''?'': lastName.toString());

    // generate password
    final password = generatePassword();
    print("password: $password");

    var body = jsonEncode({
      "email": email,
      "first_name": firstName.toString(),
      "last_name": lastName.toString(),
      "username": userName.toString(),
      "password":password.toString(),
      "billing": {
        "first_name": firstName.toString(),
        "last_name": lastName.toString(),
        "company": "",
        "address_1": addressController.text.toString(),
        "address_2": "",
        "city": cityController.text.toString(),
        "email": email,
        "phone": numberController.text.toString()
      },
      "shipping": {
        "first_name": firstName.toString(),
        "last_name": lastName.toString(),
        "company": "",
        "address_1": addressController.text.toString(),
        "address_2": "",
        "city": cityController.text.toString(),
      }
    });

    print("Body: ${body}");

    String basicAuth = 'Basic ' + base64Encode(utf8.encode((Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD)));
    print(basicAuth);

    final response = await http.post(Uri.parse(ApiUrl.BASE_URL+ApiUrl.Create_Shops),
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
        print("success");
        shop_id = data['id'].toString();
        print("shop_id $shop_id");
        Preference.setShopId(Constants.SHOP_ID, shop_id);
        _isLoading = false;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessAddShops()
            )
        );
        _formKey.currentState!.reset();
        shopnameController.clear();
        addressController.clear();
        cityController.clear();
        areaController.clear();
        numberController.clear();
        Fluttertoast.showToast(
            msg: 'Shops Created Successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
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

  void  generateRandomNumber() {

    var random = new Random();
    randomNumber = random.nextInt(1000);
    print(randomNumber.toString());

  }

  @override
  void initState() {
    // TODO: implement initState
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      FocusScope.of(context).requestFocus(null);
      if(_focusNode!.hasFocus){
        shopnameController.clear();
        addressController.clear();
        cityController.clear();
        areaController.clear();
        numberController.clear();
      }
    });
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

        child:SafeArea(
          child:Scaffold(
              resizeToAvoidBottomInset: false,
              extendBodyBehindAppBar: true,
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
              body: SingleChildScrollView(
                  child:Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 35),
                              Text(
                                "Create shop",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),

                              SizedBox(height: 24),
                              Text(
                                "Shop Name",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),
                              ),
                              TextFormField(
                                controller: shopnameController,
                                autocorrect: false,
                                enableSuggestions: false,
                                cursorColor: Colors.grey[500],
                                validator: (value) {
                                  if(value!.length == 0) {
                                    return 'Enter the shop name';
                                  } else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 16
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    hintText: 'Enter Shop Name',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    )
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Address",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),
                              ),
                              TextFormField(
                                controller: addressController,
                                autocorrect: false,
                                maxLines: 2,
                                validator: (value) {
                                  if(value!.length == 0) {
                                    return 'Enter the address';
                                  } else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                keyboardType: TextInputType.multiline,
                                enableSuggestions: false,
                                cursorColor: Colors.grey[500],

                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 16
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    hintText: 'Enter Address',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    )
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "City",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),
                              ),
                              TextFormField(
                                controller: cityController,
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if(value!.length == 0) {
                                    return 'Enter the city';
                                  } else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                cursorColor: Colors.grey[500],
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 16
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    hintText: 'Enter City',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    )
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Area",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),
                              ),
                              TextFormField(
                                controller: areaController,
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if(value!.length == 0) {
                                    return 'Enter the area';
                                  } else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                cursorColor: Colors.grey[500],
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 16
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    hintText: 'Enter Area',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    )
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Phone number",
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),

                              ),
                              TextFormField(
                                controller: numberController,
                                autocorrect: false,
                                validator: (value) {
                                  if(value!.length == 0) {
                                    return 'Enter the number';
                                  } else{
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                                enableSuggestions: false,
                                cursorColor: Colors.grey[500],
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Color(0xff757575),
                                    fontSize: 16
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade300)
                                    ),
                                    hintText: 'Enter Phone number',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                    )
                                ),

                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child:ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xffC61D1C),
                                      minimumSize: Size.fromHeight(50),
                                    ),
                                    onPressed: () async {
                                      //email random number
                                      generateRandomNumber();

                                      if(_formKey.currentState!.validate()){
                                        print("Validation");
                                        var isNetwork = await ConnectivityState.connectivityState.isNetworkAvailable();
                                        if(isNetwork == true){
                                          var name = shopnameController.text.toString();
                                          //email
                                          if(name.contains(" ")){
                                            var replaceName  = name.replaceAll(" ","");
                                            email = replaceName.toLowerCase()+ randomNumber.toString() + '@satsweets.in';
                                            userName = replaceName.toLowerCase().toString();
                                          }else{
                                            email = name.toLowerCase()+randomNumber.toString() + '@satsweets.in';
                                            userName = name.toLowerCase().toString();
                                            print("username: ${userName.toString()}");
                                          }

                                          //firstname& lastname
                                          if(name.split(" ").length>1){

                                            lastName = name.substring(name.lastIndexOf(" ")+1);
                                            firstName = name.substring(0, name.lastIndexOf(' '));
                                          }
                                          else{
                                            firstName = name;
                                          }
                                          print("first_name: ${firstName.toString()}");
                                          print("last_name: ${lastName.toString()}");
                                          print("email:${email.toString()}");
                                          createShop(firstName,lastName,email,userName);

                                        } else{
                                          ConnectivityState.showCustomDialog(
                                              context,
                                              title: "Please make sure you are connected to Internet and try again",
                                              okBtnText: 'Okay'
                                          );
                                        }
                                      } else {
                                        setState(() {
                                          _validate = true;
                                        });
                                      }

                                    },
                                    child: Text(
                                      "Add Shop",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                      )
                  )
              )
          ),
        )
    );
  }

}
