
class OrderDt {
  final String? name, quantity,total;

  OrderDt({
    this.name,
    this.quantity,
    this.total

  });

  factory OrderDt.fromJson(Map<String, dynamic> json) {
    return new OrderDt(
      name: json['name'].toString(),
      quantity: json['quantity'].toString(),
      total: json['total'].toString()
    );
  }
}
