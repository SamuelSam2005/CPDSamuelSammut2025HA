import 'package:flutter/material.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<AddWorkoutPage> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _saveWorkout() {
    String title = _titleController.text.trim();
    String duration = _durationController.text.trim();

    if (title.isEmpty || duration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
      return;
    }

    // Normally, we would send data to Firebase here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Workout '$title' added!")),
    );

    Navigator.pop(context, {"title": title, "duration": duration});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Workout Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: "Duration (minutes)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text("Save Workout"),
            ),
          ],
        ),
      ),
    );
  }
}
