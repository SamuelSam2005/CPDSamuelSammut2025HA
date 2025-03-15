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
      if (!mounted) return; // Fix async BuildContext issue
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
        if (!mounted) return; // Fix async BuildContext issue
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return; // Fix async BuildContext issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are permanently denied.")),
      );
      return;
    }

    // **Use updated `settings` parameter instead of `desiredAccuracy`**
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    if (!mounted) return; // Fix async BuildContext issue
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
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Workout Title Input**
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Workout Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 15),

            // **Workout Duration Input**
            TextField(
              controller: _durationController,
              decoration: InputDecoration(
                labelText: 'Duration (min)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // **GPS Location Display**
            if (_currentLocation != null)
              Card(
                color: Colors.grey[100],
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.location_pin, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _currentLocation!,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 15),

            // **Attach Location Button**
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location),
              label: const Text("Attach Current Location"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            const Spacer(),

            // **Save Workout Button**
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Workout', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
