// add_food_screen.dart
import 'package:flutter/material.dart';
import 'package:actually_flutter/food_item.dart'; // Import FoodItem class

class AddFoodScreen extends StatelessWidget {
  final List<FoodItem> presetFoodItems = [
    FoodItem(name: 'Apple', calories: 95),
    FoodItem(name: 'Banana', calories: 105),
    FoodItem(name: 'Chicken Breast', calories: 165),
    FoodItem(name: 'Salad', calories: 50),
    FoodItem(name: 'Pasta', calories: 200),
    FoodItem(name: 'Broccoli', calories: 55),
    FoodItem(name: 'Fish Fillet', calories: 120),
    FoodItem(name: 'Cheeseburger', calories: 300),
    FoodItem(name: 'Yogurt', calories: 80),
    FoodItem(name: 'Chocolate Bar', calories: 210),
    FoodItem(name: 'Carrot Sticks', calories: 35),
    FoodItem(name: 'Steak', calories: 250),
    FoodItem(name: 'Orange', calories: 62),
    FoodItem(name: 'Cucumber', calories: 16),
    FoodItem(name: 'Ice Cream', calories: 150),
    FoodItem(name: 'Tomato', calories: 22),
    FoodItem(name: 'Shrimp', calories: 85),
    FoodItem(name: 'Bagel', calories: 250),
    FoodItem(name: 'Almonds', calories: 7),
    FoodItem(name: 'Blueberries', calories: 29),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a preset food item:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            for (var presetItem in presetFoodItems)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, presetItem);
                },
                child: Text('${presetItem.name} (${presetItem.calories} calories)'),
              ),
            SizedBox(height: 16.0),
            Divider(),
            Text(
              'Or add a custom food item:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToCustomFoodScreen(context);
              },
              child: Text('Add Custom Food Item'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToCustomFoodScreen(BuildContext context) async {
    final customItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomFoodScreen(),
      ),
    );
    if (customItem != null) {
      Navigator.pop(context, customItem);
    }
  }
}

class CustomFoodScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Calories'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final calories = int.tryParse(caloriesController.text.trim());

                if (name.isNotEmpty && calories != null && calories > 0) {
                  final customItem = FoodItem(name: name, calories: calories);
                  Navigator.pop(context, customItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid input. Please check your entries.'),
                    ),
                  );
                }
              },
              child: Text('Add Custom Food Item'),
            ),
          ],
        ),
      ),
    );
  }
}
