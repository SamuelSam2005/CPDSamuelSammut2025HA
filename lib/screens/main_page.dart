import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/add_workout_page.dart';
import 'package:fitness_tracker/screens/edit_workout_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, String?>> workouts = [
    {"title": "Morning Run - 5km", "duration": "30", "location": null},
    {"title": "Upper Body Strength", "duration": "45", "location": null},
    {"title": "Yoga Session", "duration": "20", "location": null},
  ];

  void _addWorkout(String title, String duration, String? location) {
    setState(() {
      workouts.add({
        "title": title,
        "duration": duration,
        "location": location,
      });
    });
  }

  void _editWorkout(int index, String title, String duration, String? location) {
    setState(() {
      workouts[index] = {
        "title": title,
        "duration": duration,
        "location": location,
      };
    });
  }

  void _deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(workout["title"] ?? "Workout"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${workout["duration"]} min"),
                  if (workout["location"] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_pin, size: 16, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              workout["location"]!,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis, // Prevents overflow
                              maxLines: 1, // Ensures it stays in one line
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Text("📍 No location added"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditWorkoutPage(
                            initialTitle: workout["title"]!,
                            initialDuration: workout["duration"]!,
                            initialLocation: workout["location"],
                            onSave: (title, duration, location) {
                              _editWorkout(index, title, duration, location);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteWorkout(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddWorkoutPage(
                onSave: (title, duration, location) {
                  _addWorkout(title, duration, location);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
