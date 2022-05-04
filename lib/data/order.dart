class Order {

  List<Product_Order> list_order;

  Order({ required this.list_order });

  List toJson() => list_order;


}

  class Product_Order {
  String? productName;
  String? productQuantity;
  String? productPrice;

  Product_Order({this.productName,this.productQuantity,this.productPrice});
  Map<String, dynamic> toJson() => <String,dynamic> {
  'product_name' : productName,
  'quantity' : productQuantity,
    'price' : productPrice

  };
  Map<String, dynamic>fromJson(item) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = productName;
    data['quantity'] = productQuantity;
    data['price'] = productPrice;
    return data;

  }
  }





