class ShopMetaData{
  final int? meta_deta_id;
  final String? meta_data_balance_amnt;
  final String? meta_data_key_value;

  ShopMetaData({this.meta_deta_id, this.meta_data_balance_amnt, this.meta_data_key_value});
  factory ShopMetaData.fromJson(Map<String,dynamic> jsonData) {
    return new ShopMetaData(
        meta_deta_id: jsonData['id'],
        meta_data_key_value: jsonData['key'],
        meta_data_balance_amnt: jsonData['value']
    );
  }
}