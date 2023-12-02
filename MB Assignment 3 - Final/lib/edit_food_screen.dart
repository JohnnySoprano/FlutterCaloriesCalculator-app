import 'package:flutter/material.dart';
import 'package:actually_flutter/food_item.dart';

class EditFoodScreen extends StatelessWidget {
  final FoodItem foodItem;
  final TextEditingController nameController;
  final TextEditingController caloriesController;

  EditFoodScreen({required this.foodItem})
      : nameController = TextEditingController(text: foodItem.name),
        caloriesController = TextEditingController(text: foodItem.calories.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Food Item'),
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
                  final editedItem = FoodItem(name: name, calories: calories);
                  Navigator.pop(context, editedItem);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid input. Please check your entries.'),
                    ),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
