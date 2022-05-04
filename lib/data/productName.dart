class ProductName{
  final int? product_id;
  final String? product_name;
  final String? product_price;
  final List<ProductNameCategory>? namecategory;

  ProductName({this.product_id, this.product_name,this.product_price,this.namecategory});
  factory ProductName.fromJson(Map<String,dynamic> jsonData) {
    return new ProductName(
      product_id: jsonData['id'],
      product_name: jsonData['name'],
      product_price: jsonData['price'],
      namecategory: List<ProductNameCategory>.from(jsonData["categories"].map((x) => ProductNameCategory.fromJson(x)))
    );
  }
}

class ProductNameCategory{
  final int? id;
  final String? name;
  final String? slug;


  ProductNameCategory({this.id, this.name,this.slug});
  factory ProductNameCategory.fromJson(Map<String,dynamic> jsonData) {
    return new ProductNameCategory(
      id: jsonData['id'],
      name: jsonData['name'],
      slug: jsonData['slug']
    );
  }
}