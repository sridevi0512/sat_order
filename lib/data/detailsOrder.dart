class DetailsOrder{

  final  int? id;
  final String? first_name;
  final String? lastName;
  final String? city;
  final String? total_price;
  final String? email;
  final String? phone_number;

  DetailsOrder({ this.id,
    this.first_name,
    this.lastName,
    this.city,
    this.total_price,
    this.email,
    this.phone_number});
  factory DetailsOrder.fromJson(Map<String,dynamic> jsonData) {
    return new DetailsOrder(
        id: jsonData['id'],
        first_name: jsonData['billing']['first_name'],
        lastName: jsonData['billing']['last_name'],
        total_price: jsonData['total'],
        city: jsonData['billing']['city'],
        email: jsonData['billing']['email'],
        phone_number: jsonData['billing']['phone']


    );
  }

}