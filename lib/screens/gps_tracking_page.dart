import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSTrackingPage extends StatefulWidget {
  const GPSTrackingPage({super.key});

  @override
  State<GPSTrackingPage> createState() => _GPSTrackingPageState();
}

class _GPSTrackingPageState extends State<GPSTrackingPage> {
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled.");
      return;
    }

    // Check location permissions
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

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // Updated from deprecated desiredAccuracy
        ),
      );

      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    } catch (e) {
      _showError("Error getting location: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS Tracking")),
      body: Center(
        child: currentPosition == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Latitude: ${currentPosition?.latitude}, Longitude: ${currentPosition?.longitude}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: const Text("Update Location"),
                  ),
                ],
              ),
      ),
    );
  }
}
