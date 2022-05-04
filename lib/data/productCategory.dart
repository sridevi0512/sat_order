class ProductCategory{
  final int? category_id;
  final String? category_name;

  ProductCategory({this.category_id, this.category_name});
  factory ProductCategory.fromJson(Map<String,dynamic> jsonData) {
    return new ProductCategory(
        category_id: jsonData['id'],
        category_name: jsonData['name']
    );
  }
}