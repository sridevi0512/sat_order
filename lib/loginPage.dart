import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/homePage.dart';
import 'package:sat_order_app/loginMainPage.dart';
import 'package:sat_order_app/main.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/connectivity.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:sat_order_app/utils/preference.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool _validate = false;
  bool _isLoading = false;
  String token = '', displayName = '',id = '';
  FocusNode? _focusNode;


  Future<String?> login() async{
    print(ApiUrl.BASE_URL+ ApiUrl.Login);
     showLoaderDialog(context);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode((Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD)));
    print(basicAuth);

    final response = await http.post(Uri.parse(ApiUrl.BASE_URL + ApiUrl.Login),
        headers: <String,String>{'authorization': basicAuth},
        body: {
          'username': usernameController.text,
          'password': passwordController.text
        });
    try{
      var data = json.decode(response.body);
      print("data $data" );
      if(data["success"] == true){
        print("success");
        _isLoading = false;
        token = data['data']['token'];
        print("token $token");
        displayName = data['data']['firstName'];
        print("userName $displayName");
        id = data['data']['id'].toString();
        print("id $id");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("user_token", token);
        Preference.setUserName(Constants.USER_NAME, displayName);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()
            )
        );
        formKey.currentState?.reset();
        usernameController.clear();
        passwordController.clear();
        Fluttertoast.showToast(
            msg: data['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      } else {
         // _isLoading = false;
        Navigator.pop(context);
        Fluttertoast.showToast(msg: data['message'],
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
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      FocusScope.of(context).requestFocus(null);
      if(_focusNode!.hasFocus){ usernameController.clear();
      passwordController.clear();};
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark
    ));
    return GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child:SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  centerTitle: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      SizedBox(
                          // width: 30,
                          child:
                          IconButton(
                              onPressed: () {
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginMainPage()),
                                );
                              },
                              icon: Image.asset(
                                  "images/back-arrow.png"
                              ),
                               iconSize: 18,
                              color: Color(0xff7a7a7a))
                      )
                    ],
                  ),
                ),
                body: Stack(
                    children:[
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child:Image.asset(
                            "images/sat-sweet-logo.png",
                            fit: BoxFit.none,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: (){
                            FocusScope.of(context).requestFocus(new FocusNode());
                          },
                          child:Container(
                            child: new Form(
                                key: formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                child:Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(height: 10),

                                      Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child:Text(
                                            "Login",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 25,
                                              fontWeight: FontWeight.w600
                                            ),
                                          )
                                      ),

                                      SizedBox(
                                        height: 10,
                                      ),

                                      Padding(
                                          padding: EdgeInsets.only(left: 15,top: 10),
                                          child:Text(
                                            "Username",
                                            style: TextStyle(
                                                color: Color(0xff7a7a7a),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18
                                            ),
                                          )
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 15,right: 15,top: 2),
                                        child: TextFormField(
                                          controller: usernameController,
                                          cursorColor: Color(0xff7a7a7a),
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          validator: (value) {
                                            if(value!.isEmpty){
                                              return "Username is required";
                                            }
                                            else return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.none
                                          ),
                                          decoration: InputDecoration(
                                              enabledBorder:UnderlineInputBorder(
                                                  borderSide:BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              // contentPadding: EdgeInsets.all(10),
                                              hintText: "UserName",
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff7a7a7a)
                                              )
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 15,top: 10),
                                          child:Text(
                                            "Password",
                                            style: TextStyle(
                                                color: Color(0xff7a7a7a),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18
                                            ),
                                          )
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 15,right: 15,top: 2),
                                        child: TextFormField(
                                          controller: passwordController,
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          obscureText: _isVisible? false: true,
                                          cursorColor: Color(0xff7a7a7a),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              decoration: TextDecoration.none
                                          ),
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Password is required';
                                            }else return null;
                                          },
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          decoration: InputDecoration(
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isVisible = !_isVisible;
                                                  });
                                                },
                                                child: Container(
                                                  child: Icon(
                                                    _isVisible?
                                                    Icons.visibility_rounded:
                                                    Icons.visibility_off_sharp,
                                                    color: Color(0xff7a7a7a),
                                                  ),
                                                ),
                                              ),
                                              enabledBorder:UnderlineInputBorder(
                                                  borderSide:BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff7a7a7a))
                                              ),
                                              // contentPadding: EdgeInsets.all(10),
                                              hintText: "Password",
                                              hintStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff7a7a7a)
                                              )
                                          ),
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
                                              if(formKey.currentState!.validate()){
                                                print("Validation");
                                                var isNetwork = await ConnectivityState.connectivityState.isNetworkAvailable();
                                                if(isNetwork == true){
                                                  login();
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
                                              "Log In",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),


                                    ]
                                )
                            ),
                          ),
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}
