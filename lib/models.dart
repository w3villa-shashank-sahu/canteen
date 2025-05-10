class Student {
  String name;
  String rollno;
  String id;
  List<Products> products; // emergency products
  double balance; // regular balance

  Student({
    required this.name,
    required this.rollno,
    required this.id,
    required this.products,
    required this.balance,
  });

  double totalPrice() {
    return products.fold(0.0, (previousValue, element) => element.price * element.quantity + previousValue);
  }
}

class Products {
  int quantity;
  String id;
  String name;
  double price;

  Products({
    required this.quantity,
    required this.id,
    required this.name,
    required this.price,
  });
}
