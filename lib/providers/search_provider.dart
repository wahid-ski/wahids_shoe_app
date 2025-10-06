import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  bool get isSearching => _searchQuery.isNotEmpty;

  void updateSearchQuery(String query){
      _searchQuery = query.toLowerCase().trim();
        notifyListeners();
  }
  void clearSearch(){
    _searchQuery = '';
    notifyListeners();
  }

}
