import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sat_order_app/loginPage.dart';

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({Key? key}) : super(key: key);

  @override
  _LoginMainPageState createState() => _LoginMainPageState();
}



class _LoginMainPageState extends State<LoginMainPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark
    ));
    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child:Text(
                    "Welcome to SAT Sweets \n "
                        "Order Management APP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Expanded(
                child: Center(
                    child:Image.asset(
                      "images/sat-sweet-logo.png",
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Expanded(
                  child:Padding(
                    padding: EdgeInsets.all(30),
                    child: Center(
                      child:ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xffC61D1C),
                          minimumSize: Size.fromHeight(50)
                        ),
                        onPressed: (){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()
                              )
                          );
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
                  )
              ),
            ],
          )
      ),
    );
  }
}
