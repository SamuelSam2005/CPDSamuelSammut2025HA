import 'package:flutter/material.dart';
import 'add_workout_page.dart'; // Import the AddWorkoutPage

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> workouts = [
    "Morning Run - 5km",
    "Upper Body Strength",
    "Yoga Session",
    "HIIT Workout"
  ];

  void _addNewWorkout(Map<String, String> workout) {
    setState(() {
      workouts.add("${workout['title']} - ${workout['duration']} min");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        centerTitle: true,
      ),
      body: workouts.isEmpty
          ? const Center(child: Text("No workouts added yet!"))
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(workouts[index]),
                    leading: const Icon(Icons.fitness_center),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          workouts.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
          );

          if (result != null) {
            _addNewWorkout(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
