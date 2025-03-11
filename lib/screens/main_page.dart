import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'List of workouts will appear here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
