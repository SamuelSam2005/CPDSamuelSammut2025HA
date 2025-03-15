import 'package:flutter/material.dart';

class EditWorkoutPage extends StatefulWidget {
  final String initialTitle;
  final String initialDuration;
  final String? initialLocation;
  final Function(String, String, String?) onSave; // Ensure this is defined

  const EditWorkoutPage({
    super.key,
    required this.initialTitle,
    required this.initialDuration,
    this.initialLocation,
    required this.onSave,
  });

  @override
  State<EditWorkoutPage> createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _durationController = TextEditingController(text: widget.initialDuration);
  }

  void _saveWorkout() {
    final title = _titleController.text;
    final duration = _durationController.text;
    widget.onSave(title, duration, widget.initialLocation);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Workout')),
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
            ElevatedButton(
              onPressed: _saveWorkout,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
