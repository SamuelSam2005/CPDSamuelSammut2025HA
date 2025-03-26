import 'package:flutter/material.dart';

/// A simple responsive demo screen for assignment requirement
class ResponsiveDemoPage extends StatelessWidget {
  const ResponsiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Define size type
    String screenType;
    if (screenWidth < 600) {
      screenType = 'Small Screen';
    } else if (screenWidth < 1200) {
      screenType = 'Medium Screen';
    } else {
      screenType = 'Large Screen';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.devices, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              Text(
                screenType,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Screen width: ${screenWidth.toStringAsFixed(0)} px',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                'This layout adapts based on screen width.\nRun on Different screen sizes/emulators to calibrate the fitness app accordingly!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
