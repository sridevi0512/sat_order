import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sat_order_app/utils/apiUrl.dart';
import 'package:sat_order_app/utils/constants.dart';
import 'package:http/http.dart' as http;

import 'data/productName.dart';

class genBill extends StatefulWidget {
  const genBill({Key? key}) : super(key: key);

  @override
  _genBillState createState() => _genBillState();
}

class _genBillState extends State<genBill> {

  List<String> productListItem = [];
  List<String> priceListItem = [];
  List<TextEditingController> productcontroller = [];
  List<TextEditingController> pricecontroller = [];
  List<ProductName> dropdownlist = [];
  List<String> dropList =[];
  int shopitems = 1;
  int? cost ;

  Future<String?> selectProduct() async {
    print(ApiUrl.BASE_URL + ApiUrl.Product);
    String basicAuth = 'Basic ' + base64Encode(utf8.encode(Constants.AUTH_USERNAME + ':' + Constants.AUTH_PASSWORD ));
    print(basicAuth);
    final queryParameters = {
      'category': '21',
    };
    var url = Uri.parse(ApiUrl.BASE_URL + ApiUrl.Product);
    final newURI = url.replace(queryParameters: queryParameters);
    print(newURI);
    var response = await http.get(newURI, headers: {
      'Authorization': basicAuth,

    });
    try{
      var data = json.decode(response.body);
      print(data);
      dropdownlist = (data).map<ProductName>((item) => ProductName.fromJson(item)).toList();

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
    selectProduct();
  }

  addItems() {
    setState(() {
      shopitems = shopitems +1 ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
          mainAxisSize: MainAxisSize.min,
            children:[

              // Expanded(
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shopitems,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      productcontroller.add(new TextEditingController());
                      pricecontroller.add(new TextEditingController());
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 10),
                                  Flexible(
                                    child:DropdownButtonFormField<String>(
                                      isExpanded: true,
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
                                      ),

                                      hint:  Center(
                                          child:Text('Select',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: Colors.grey[600]))),

                                      items: dropdownlist
                                          .map((ProductName selectlist) {
                                        return DropdownMenuItem<String>(
                                          value: selectlist.product_name,
                                          child: Text(selectlist.product_name!.toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18)),
                                        );
                                      }).toList(),
                                      onChanged: (String? newvalue){
                                        setState(() {
                                          dropList.insert(index, newvalue!);
                                        });

                                      },
                                      // value: this.dropList[index].toString(),

                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child:TextFormField(
                                      autofocus: false,
                                      onChanged: (value){
                                        productListItem.insert(index, value);
                                      },
                                      controller: productcontroller[index],
                                      keyboardType: TextInputType.multiline,
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
                                          hintText: "Product",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child:TextFormField(
                                      autofocus: false,
                                      onChanged: (value){
                                        priceListItem.insert(index, value);
                                        setState(() {
                                          cost = int.parse(pricecontroller[index].text);
                                          print(cost);
                                        });

                                      },
                                      controller: pricecontroller[index],
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
                                          hintText: "Price",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18)),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child:Text(
                                      (cost == null)? ' Rs. 0':"Rs. ${cost.toString()} ",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                    ),
                                    iconSize: 25,
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                         dropdownlist.removeAt(index);
                                        productcontroller.removeAt(index);
                                        pricecontroller.removeAt(index);
                                        setState(() {
                                          shopitems = shopitems-1;
                                        });;

                                      });
                                    },
                                  ),

                                ],
                              ),
                              ElevatedButton(
                                onPressed: (){addItems();},
                                child: Text("Add Product"),
                              ),
                            ],


                          ),
                        ),

                      );
                    },
                  )
              // )
            ]
        )

    );
  }
}
/*getCheckboxItems() {
    _isChecked!.forEach((key, value) {
      if(value == true) {
        selectedItemsArray.add(key);
      }
    });
    print("SelectedCheckboxItems: $selectedItemsArray");
    selectedItemsArray.clear();
  }
  submitData() {
    Quantity = [];
    Price = [];
    /* dynamicList.forEach((widget) => Quantity.add(widget.toString()));
    dynamicList.forEach((widget) => Price.add(widget.toString()));*/
    setState(() {});
    print(Quantity.length);
  }*/

/* children: _category.map((ProductCategory key) {
                                          return new
                                          ExpansionTile(
                                              children: [
*//*                                                ListView.builder(
                                                  shrinkWrap:true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: achievementslistcount.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    print("error");
                                                    desccorntroller.add(new TextEditingController());
                                                    return Column(
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
                                                                    "Quantity",
                                                                    style: TextStyle(
                                                                        color: Color(0xff767676),
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: 16
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.all(10),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Padding(
                                                                      padding: EdgeInsets.only(left: 10,top: 10),
                                                                      child: DecoratedBox(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey.shade50,
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            boxShadow: <BoxShadow> [
                                                                              BoxShadow(
                                                                                  color: Colors.grey.shade300,
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
                                                                          padding: EdgeInsets.only(left: 10,right: 10),
                                                                          child: DropdownButton(
                                                                            isExpanded: true,
                                                                            hint: dropdownItemList == null?
                                                                            Text('Item',
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: Colors.grey[600]
                                                                              ),
                                                                            ):
                                                                            Text(
                                                                              dropdownItemList!,
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16,
                                                                                  color: Colors.grey[600]
                                                                              ),
                                                                            ),
                                                                            icon: Image.asset("images/downarrow.png"),
                                                                            underline: Container(),
                                                                            items: itemList.map((e) {
                                                                              return DropdownMenuItem(
                                                                                value: e,
                                                                                child: Container(
                                                                                  child: Text(e,
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontSize: 18,
                                                                                        color: Colors.grey[600]
                                                                                    ),),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged: (String? value) {
                                                                              setState(() {
                                                                                listDataItem[index] = value!;
                                                                                selectItem = listDataItem[index];
                                                                                print("selectItem $selectItem");
                                                                              });
                                                                            },
                                                                            value: this.listDataItem[index],
                                                                          ),
                                                                        ),
                                                                      )
                                                                  ),

                                                                ),
                                                                Flexible(child:
                                                                TextFormField(
                                                                  controller: desccorntroller[index],
                                                                  cursorColor: Colors.grey,
                                                                  onChanged: (value) {
                                                                    Quantity.insert(index, value);
                                                                  },
                                                                  autocorrect: false,
                                                                  enableSuggestions: false,
                                                                  keyboardType: TextInputType.number,

                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.grey[600],
                                                                      decoration: TextDecoration.none
                                                                  ),
                                                                  decoration: InputDecoration(
                                                                      hintText: "Quantity",
                                                                      border: InputBorder.none,
                                                                      hintStyle: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Colors.grey[600]
                                                                      )
                                                                  ),
                                                                ),
                                                                ),
                                                                Flexible(
                                                                  child: TextFormField(
                                                                    controller: priceController,
                                                                    cursorColor: Colors.grey,
                                                                    keyboardType: TextInputType.number,
                                                                    autocorrect: false,
                                                                    enableSuggestions: false,

                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.grey[600],
                                                                        decoration: TextDecoration.none
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                        hintText: "Price",
                                                                        border: InputBorder.none,*//**//*OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                color: Color(0xff767676)
                                                              )
                                                            ),*//**//*
                                                                        hintStyle: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.w600,
                                                                            color: Colors.grey[600]
                                                                        )
                                                                    ),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "Rs : ${priceController.text.toString()}",
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.normal
                                                                  ),
                                                                ),


                                                              ],
                                                            ),),
                                                          Align(
                                                            alignment: Alignment.bottomRight,
                                                            child: ElevatedButton(
                                                              onPressed: (){},
                                                              style: ElevatedButton.styleFrom(
                                                                  primary: Color(0xffD8D2D2),
                                                                  textStyle: TextStyle(
                                                                      color: Colors.red)),
                                                              child: Text(
                                                                "Add Product",
                                                                style: TextStyle(
                                                                    color: Color(0xffc31d1c),
                                                                    fontSize: 15
                                                                ),
                                                              ),
                                                            ),
                                                          )]
                                                    );
                                                  },
                                                )*//*

                                                (dynamicList.length == 0)? Container():
                                                Expanded(
                                                    child:LayoutBuilder(
                                                        builder:(BuildContext context, BoxConstraints constraints) {
                                                          print("dynamicList ${dynamicList.length}");
                                                          return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: dynamicList.length,
                                                            itemBuilder: (_, index) => dynamicList[index],
                                                          );
                                                        }
                                                    )
                                                )
                                              ],
                                              title: CheckboxListTile(
                                                title: new GestureDetector(
                                                    onTap: (){
                                                      ExpansionTile(
                                                        title: Text(key.category_name!),
                                                        children: [
                                                        ],
                                                      );
                                                    },
                                                    child:Text(key.category_name!)),
                                                value: _isChecked![index],
                                                activeColor: Colors.grey,
                                                checkColor: Colors.white,
                                                controlAffinity: ListTileControlAffinity.leading,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _isChecked![index] = value!;
                                                  });
                                                },
                                              )

                                          );
                                        }).toList(),
*/
