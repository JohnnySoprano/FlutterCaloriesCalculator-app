// main.dart
import 'package:flutter/material.dart';
import 'package:actually_flutter/add_food_screen.dart';
import 'package:actually_flutter/edit_food_screen.dart';
import 'package:actually_flutter/food_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Items',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<FoodItem> foodItems = [];
  int maxCalories = 2000;
  final TextEditingController _maxCaloriesController = TextEditingController();
  DateTime? selectedDate;

  int get totalCalories {
    return foodItems.isNotEmpty
        ? foodItems.map((item) => item.calories).reduce((a, b) => a + b)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    List<FoodItem> filteredFoodItems = selectedDate != null
        ? foodItems.where((item) => item.date.isAtSameMomentAs(selectedDate!)).toList()
        : List.from(foodItems);

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Items'),
      ),
      body: Column(
        children: [
          // UI element to pick a date
          ElevatedButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null && pickedDate != selectedDate) {
                setState(() {
                  selectedDate = pickedDate;
                });
              }
            },
            child: Text(selectedDate != null
                ? 'Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                : 'Select a Date'),
          ),

          if (foodItems.isEmpty)
            Center(
              child: Text('No food items added.'),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredFoodItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredFoodItems[index].name),
                    subtitle: Text(
                      '${filteredFoodItems[index].calories} calories\nAdded: ${_formatDate(filteredFoodItems[index].date)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _navigateToEditFoodScreen(filteredFoodItems[index]);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              foodItems.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                _setMaxCalories(context);
              },
              child: Text(
                'Max Calories: $maxCalories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: totalCalories <= maxCalories ? Colors.green : Colors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Total Calories: $totalCalories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newFoodItem = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodScreen(),
            ),
          );
          if (newFoodItem != null) {
            setState(() {
              foodItems.add(newFoodItem);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _setMaxCalories(BuildContext context) async {
    _maxCaloriesController.text = maxCalories.toString();

    final result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Max Calories'),
          content: TextField(
            controller: _maxCaloriesController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Max Calories'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final max = int.tryParse(_maxCaloriesController.text.trim()) ?? 0;
                if (max >= 0) {
                  Navigator.pop(context, max);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enter a valid non-negative integer'),
                    ),
                  );
                }
              },
              child: Text('Set'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        maxCalories = result;
      });
    }
  }

  Future<void> _navigateToEditFoodScreen(FoodItem foodItem) async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFoodScreen(foodItem: foodItem),
      ),
    );
    if (updatedItem != null) {
      setState(() {
        foodItems[foodItems.indexOf(foodItem)] = updatedItem;
      });
    }
  }
}
