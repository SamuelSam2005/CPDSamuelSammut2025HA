import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  Position? _currentPosition;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError("Location permissions are permanently denied.");
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      _showError("Error getting location: $e");
    }
  }

  void _saveWorkout() {
    String title = _titleController.text.trim();
    String duration = _durationController.text.trim();
    
    if (title.isEmpty || duration.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    String location = _currentPosition != null
        ? "Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}"
        : "No location added";

    // Simulating saving the workout
    Navigator.pop(context, {
      "title": title,
      "duration": duration,
      "location": location,
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Workout")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Workout Title"),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: "Duration (minutes)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Attach GPS Location (Optional)"),
            ),
            const SizedBox(height: 10),
            _currentPosition != null
                ? Text("Attached Location: Lat: ${_currentPosition!.latitude}, Lng: ${_currentPosition!.longitude}")
                : const Text("No location added"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _saveWorkout,
                child: const Text("Save Workout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
