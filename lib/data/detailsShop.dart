class DetailsS{
  final  int? id;
  final String? first_name;
  final String? lastName;
  final String? address;
  final String? city;
  final String? phone_number;

  DetailsS({ this.id, this.first_name, this.lastName, this.address, this.city, this.phone_number});
  factory DetailsS.fromJson(Map<String,dynamic> jsonData) {
  return new DetailsS(
  id: jsonData['id'],
  first_name: jsonData['first_name'],
  lastName: jsonData['billing']['last_name'],
  address: jsonData['billing']['address_1'],
  city: jsonData['billing']['city'],
  phone_number: jsonData['billing']['phone'],

  );
  }

}