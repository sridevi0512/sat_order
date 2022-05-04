class PdtItem {
  String? productName;
  String? productQuantity;
  String? productPrice;

  PdtItem({this.productName, this.productQuantity, this.productPrice});

  factory PdtItem.toJson(Map<String, dynamic> data) {
    return new PdtItem(
        productName: data['product_name'],
        productQuantity: data['quantity'],
      productPrice: data['price']
    );
  }
}