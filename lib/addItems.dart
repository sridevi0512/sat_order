import 'package:flutter/material.dart';

class AddItemsPage extends StatefulWidget {


  const AddItemsPage({Key? key}) : super(key: key);

  @override
  _AddItemsPageState createState() => _AddItemsPageState();
}

class _AddItemsPageState extends State<AddItemsPage> {
  String? dropdownItemList, selectItem;
  List<String> itemList = ["Item 1", "Item 2", "Item3", "Item 4"];
  TextEditingController quantityController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController costController = new TextEditingController();
  List<AddItemsPage> dynamicList = [];
  List<String> Quantity = [];
  List<String> Price = [];
  List<String> Cost = [];

  addDynamic() {
    if(Quantity.length != 0 ){
      Quantity = [];
      Price = [];
      dynamicList = [];
    }
    setState(() {
      if(dynamicList.length >= 10){
        return;
      }
      dynamicList.add(new AddItemsPage());
    });
  }
/*
  submitData() {
     Quantity = [];
    Price = [];
    Cost = [];
    dynamicList.forEach((widget) => Quantity.add(Quantity.toString()));
    dynamicList.forEach((widget) => Price.add(Price.toString()));
    dynamicList.forEach((widget) => Cost.add(Cost.toString()));
    setState(() {});
    print(Quantity.length);
  }
*/
  removeDynamic(index) {
    setState(() {

    });
    print("dynamiclength: ${dynamicList.length}");
    dynamicList.removeAt(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("costController : ${costController.text.toString()}");

    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: Quantity.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 10.0),
                      child: new Text("${index + 1} : ${Quantity[index]} ${Price[index]} ${Cost[index]}"),
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));
    return SafeArea(

      child: SizedBox(
        height: double.infinity,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        body:
        Column(
          children: [

            Align(
              alignment: Alignment.topRight,
            child:Padding(
              padding: EdgeInsets.only(top: 5,left: 10,right: 10,bottom: 5),
              child:Text(
              "Cost",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.grey[600]
              ),
            ),
            ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              dropdownItemList = value!;
                              selectItem = dropdownItemList!;
                              print("selectItem $selectItem");
                            });
                          },
                        ),
                      ),
                    )
                ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child:DecoratedBox(
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

                    child: TextFormField(
                      controller: quantityController,
                      cursorColor: Colors.grey,
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
                ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child:DecoratedBox(
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
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600]
                            )
                        ),
                      ),

                  ),
                )
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 20),
                    child: TextFormField(
                      controller: costController,
                      cursorColor: Colors.grey,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        decoration: TextDecoration.none
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:  "Cost",
                          hintStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600]
                          ),
                        prefixText: "Rs. " ,
                        prefixStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal
                        )
                      ),
                    ),
                ),
                ),
                (dynamicList.length == 0)?
                   Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: (){
                         addDynamic();
                        // dynamicTextField;
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          image:DecorationImage(
                          image:ExactAssetImage(
                            "images/plus-icon.png",
                          )
                          )
                        ),
                      ),

                    ),
                  ):
                    Container()
/*                Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: (){
                      int index = dynamicList.length;
                       removeDynamic(index);
                    },
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: ExactAssetImage(
                            "images/minus.png"
                          )
                        )
                      ),
                    ),
                  ),
                ),*/

              ],
            ),
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
        ),
      ),
      ),
      );
  }
}
