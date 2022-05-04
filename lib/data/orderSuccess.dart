import 'package:flutter/material.dart';

import '../homePage.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  _OrderSuccessState createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child:Image.asset(
                "images/like.png",
                fit: BoxFit.cover,
              )
          ),
          SizedBox(height: 10),

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
              "You have successfully \n"
                  "completed your order",
              style: TextStyle(
                  color: Color(0xff767676),
                  fontWeight: FontWeight.w500,
                  fontSize: 18
              ),
            ),
          ),

          SizedBox(height: 20),
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
                    "Back to Home",
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
