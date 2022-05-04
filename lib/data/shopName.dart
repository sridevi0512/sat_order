class ShopName{
   final  int? id;
  final String? shopName;
  final String? lastName;
  final List<ShopLineList>? linelist;

  ShopName({ this.id, this.shopName, this.lastName,this.linelist});
  factory ShopName.fromJson(Map<String,dynamic> jsonData) {
    return new ShopName(
      id: jsonData['id'],
      shopName: jsonData['username'],
      lastName: jsonData['last_name'],
      linelist: List<ShopLineList>.from(jsonData["meta_data"].map((x) => ShopLineList.fromJson(x)))

    );
  }
}

class ShopLineList{
  final int? id;
  final String? key;
  final String? value;

  ShopLineList({
    this.id,
    this.key,
    this.value
});
  factory ShopLineList.fromJson(Map<String,dynamic> jsonData){
    return new ShopLineList(
      id: jsonData['id'],
      key: jsonData['key'],
      value: jsonData['value']
    );
  }
}