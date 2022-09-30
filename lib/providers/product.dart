import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final oldFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https('shop-app-flutter-e5239-default-rtdb.firebaseio.com',
        '/products/$id.json');

    try {
      final res = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (res.statusCode >= 400) {
        isFavorite = oldFavoriteStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = oldFavoriteStatus;
      notifyListeners();
      rethrow;
    }
  }
}



    // _items.removeAt(existingProductIndex);
    // notifyListeners();

    // final res = await http.delete(url);

    // if (res.statusCode >= 400) {
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   throw HttpException('Could not delete product.');
    // }
    // existingProduct = null;