// food_item.dart
import 'package:flutter/material.dart';

class FoodItem {
  String name;
  int calories;
  DateTime timestamp;

  FoodItem({required this.name, required this.calories})
      : timestamp = DateTime.now().toLocal(); // Store the current date and time

  // Getter to retrieve only the date part
  DateTime get date => DateTime(timestamp.year, timestamp.month, timestamp.day);
}
