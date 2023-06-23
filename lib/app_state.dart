import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  var progress = <DateTime>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var selectedIndex = 0;

  void changeIndex(int i) {
    selectedIndex = i;
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
