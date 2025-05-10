// import 'dart:core';

import 'package:canteen/models.dart';

class Backend {
  // fetch Student data with alloted products for current day
  Future<Student> fetchData(String id) async {
    return Student(
        name: 'Shashank',
        rollno: '2301650140081',
        id: '232780',
        products: [
          Products(quantity: 4, id: 'p1', name: 'Pizza', price: 300),
          Products(quantity: 2, id: 'p2', name: 'Chai', price: 10)
        ],
        balance: 10000);
  }

  Future<bool> makePurchase(String id, double amount) async {
    return true;
  }
}
