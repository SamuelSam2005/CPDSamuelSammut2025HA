import 'package:flutter/material.dart';
import 'add_workout_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> workouts = [
    "Morning Run",
    "Upper Body Strength",
    "Yoga Session",
    "HIIT Workout"
  ];

  void _addNewWorkout(Map<String, String> workout) {
    setState(() {
      workouts.add("${workout['title']} - ${workout['duration']} min");
    });
  }

  void _removeWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: workouts.isEmpty
          ? const Center(
              child: Text(
                "No workouts added yet!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    title: Text(
                      workouts[index],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    leading: const Icon(Icons.fitness_center, color: Colors.deepPurpleAccent),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeWorkout(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
          );

          if (result != null) {
            _addNewWorkout(result);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("New Workout"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
