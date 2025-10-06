import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> favorites = [];

  void addFavorite(Map<String, dynamic> product) {

    final exists = favorites.any((item) => item['id'] == product['id']);
    if (!exists) {
      favorites.add(product);
      notifyListeners();
    }
  }
  
  void removeFavorite(Map<String, dynamic> product) {
    
    favorites.removeWhere((item) => item['id'] == product['id']);
    notifyListeners();
  }
  

  bool isFavorite(String productId) {
    return favorites.any((item) => item['id'] == productId);
  }
}