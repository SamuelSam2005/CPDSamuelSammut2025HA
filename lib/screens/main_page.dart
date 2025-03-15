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
        title: const Text(
          'Workouts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Duration Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            workout["title"] ?? "Workout",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${workout["duration"]} min",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location Display
                    if (workout["location"] != null)
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: Colors.red),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              workout["location"]!,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      const Text(
                        "📍 No location added",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                    // Buttons Row
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
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
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text("Edit"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () => _deleteWorkout(index),
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
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
        icon: const Icon(Icons.add),
        label: const Text("Add Workout"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
