import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'shop-app-flutter-e5239-default-rtdb.firebaseio.com', '/orders.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        var productsArray = orderData['products'] as List;

        List<CartItem> products =
            productsArray.map((prod) => CartItem.fromJson(prod)).toList();

        loadedOrders.insert(
            0,
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: products,
              dateTime: DateTime.parse(orderData['dateTime']),
            ));
      });
      _orders = loadedOrders;

      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    if (cartProducts.isNotEmpty) {
      final timestamp = DateTime.now();
      final url = Uri.https(
          'shop-app-flutter-e5239-default-rtdb.firebaseio.com', '/orders.json');

      try {
        // dynamic myDateSerializer(dynamic object) {
        //   if (object is DateTime) {
        //     return object.toIso8601String();
        //   }
        //   return object;
        // }

        final res = await http.post(url,
            body: jsonEncode({
              'amount': total,
              'products': cartProducts,
              'dateTime': timestamp.toIso8601String()
            }));

        final newOrder = OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp);

        _orders.insert(0, newOrder);
        notifyListeners();
      } catch (err) {
        rethrow;
      }
    }
  }
}
