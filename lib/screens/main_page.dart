import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fitness_tracker/screens/add_workout_page.dart';
import 'package:fitness_tracker/screens/edit_workout_page.dart';
import 'package:fitness_tracker/services/notification_service.dart';


//Main Page thaty contains workouts, allows the user to add, edit, delete workouts that are stored in firebase
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

//Replaced Dummy Data with a lines of code to take data from the RealTime Database
class _MainPageState extends State<MainPage> {
  final DatabaseReference _workoutsRef =
      FirebaseDatabase.instance.ref().child('workouts');

  //List to store workout data
  List<Map<String, dynamic>> workouts = [];

  @override
  void initState() {
    super.initState();
    _listenToWorkouts();
  }
  // Checks for changes made in the realtime databse
  void _listenToWorkouts() {
    _workoutsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Map<String, dynamic>> loadedWorkouts = [];

        data.forEach((key, value) {
          final workout = Map<String, dynamic>.from(value);
          workout['key'] = key;
          loadedWorkouts.add(workout);
        });

        setState(() {
          workouts = loadedWorkouts;
        });
      } else {
        setState(() {
          workouts = [];
        });
      }
    });
  }

  // Adds a workout to fiorebase
  void _addWorkout(String title, String duration, String? location) {
    final newRef = _workoutsRef.push();
    newRef.set({
      'title': title,
      'duration': duration,
      'location': location,
    });

    //Shows a notification when adding a workout
    NotificationService.showNotification(
      title: "Workout Added",
      body: "You've added $title for $duration minutes!",
    );
  } 
  //Edit an existing workout
  void _editWorkout(String key, String title, String duration, String? location) {
    _workoutsRef.child(key).set({
      'title': title,
      'duration': duration,
      'location': location,
    });

    // Shows a notification when a workout is updated
    NotificationService.showNotification(
      title: "Workout Updated",
      body: "$title was updated successfully.",
    );
  }

  //Delete an existing workout
  void _deleteWorkout(String key, String? deletedTitle) {
    _workoutsRef.child(key).remove();

    //Shows a notification when a workout is deleted
    NotificationService.showNotification(
      title: "Workout Deleted",
      body: "$deletedTitle has been removed.",
    );
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
        child: workouts.isEmpty
            ? const Center(child: Text("No workouts found."))
            : ListView.builder(
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "${workout["duration"]} min",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Location Display
                          if (workout["location"] != null &&
                              workout["location"].toString().trim().isNotEmpty)
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 18, color: Colors.red),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    workout["location"],
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
                                        initialTitle: workout["title"] ?? "",
                                        initialDuration: workout["duration"] ?? "",
                                        initialLocation: workout["location"],
                                        onSave: (title, duration, location) {
                                          _editWorkout(workout["key"], title, duration, location);
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
                                onPressed: () {
                                  _deleteWorkout(workout["key"], workout["title"]);
                                },
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
