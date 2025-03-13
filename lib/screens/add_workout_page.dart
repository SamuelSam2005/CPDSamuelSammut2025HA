import 'package:flutter/material.dart';

class AddWorkoutPage extends StatelessWidget {
  const AddWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: const Center(
        child: Text("Workout creation form will be added here."),
      ),
    );
  }
}
