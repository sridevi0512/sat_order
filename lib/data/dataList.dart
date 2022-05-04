class DataList {
  List<ListOrder> list;

  DataList({ required this.list});

  List toJson() =>  list;

}

class ListOrder {
  String? productId;
  String? quantity;
  String? sale_price;
  ListOrder({this.productId,this.quantity,this.sale_price});
  Map<String, dynamic> toJson() => <String,dynamic> {
    'product_id' : productId,
    'quantity' : quantity,
     'sale_price' : sale_price
  };
}