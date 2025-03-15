import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AddWorkoutPage extends StatefulWidget {
  final Function(String, String, String?) onSave;

  const AddWorkoutPage({super.key, required this.onSave});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _currentLocation; // Store the location

  /// **Fetch the user's location**
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // **Check if location services are enabled**
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    // **Check location permissions**
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are permanently denied.")),
      );
      return;
    }

    // **Get the current position**
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    if (!mounted) return;
    setState(() {
      _currentLocation = "Lat: ${position.latitude}, Lng: ${position.longitude}";
    });
  }

  /// **Save the workout with or without location**
  void _saveWorkout() {
    final title = _titleController.text;
    final duration = _durationController.text;
    if (title.isNotEmpty && duration.isNotEmpty) {
      widget.onSave(title, duration, _currentLocation);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Workout Title'),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // **GPS Location Display**
            if (_currentLocation != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  Text(_currentLocation!, style: const TextStyle(fontSize: 16)),
                ],
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Attach Current Location"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Save Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
