import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/add_workout_page.dart';
import 'package:fitness_tracker/screens/gps_tracking_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> _workouts = [
    {'title': 'Morning Run - 5km', 'location': null},
    {'title': 'Upper Body Strength', 'location': null},
    {'title': 'Yoga Session', 'location': null},
  ];

  void _addWorkout(String title, String? location) {
    setState(() {
      _workouts.add({'title': title, 'location': location});
    });
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  void _navigateToAddWorkout() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddWorkoutPage()),
    );

    if (result != null && result is Map<String, String?>) {
      _addWorkout(result['title']!, result['location']);
    }
  }

  void _navigateToGPSTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GPSTrackingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(_workouts[index]['title']),
              subtitle: _workouts[index]['location'] != null
                  ? Text('📍 ${_workouts[index]['location']}')
                  : null,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteWorkout(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }
}
