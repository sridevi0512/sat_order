import 'package:flutter/material.dart';
import 'package:sat_order_app/homePage.dart';

class SuccessAddShops extends StatefulWidget {
  const SuccessAddShops({Key? key}) : super(key: key);

  @override
  _SuccessAddShopsState createState() => _SuccessAddShopsState();
}

class _SuccessAddShopsState extends State<SuccessAddShops> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child:Icon(
                Icons.home_sharp,
                size: 30,
              )
          ),
          SizedBox(height: 20),
          Center(
          child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Center(
                        child: Text(
                          "Confirmation",
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                              fontSize: 30
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Center(
                        child:Text(
                          "Shop Added Successfully",
                          style: TextStyle(
                              color: Color(0xff767676),
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ]
                ),

                SizedBox(width: 5),
                Container(
                    height: 55,
                    width: 55,
                    child:Image.asset(
                      "images/success.png",
                      fit: BoxFit.cover,
                    )
                )
              ]
          ),
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              "images/sat-sweet-logo.png",
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xffC61D1C),
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    Navigator.of(context).
                    push(MaterialPageRoute(builder: (context) =>
                        HomePage()));

                  },
                  child: Text(
                    "Place Order",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
