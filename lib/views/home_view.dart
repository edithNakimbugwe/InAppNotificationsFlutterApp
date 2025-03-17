import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/reminder_controller.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    Provider.of<ReminderController>(context, listen: false).fetchReminders();
  }

  void _addReminder() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _selectedDateTime != null) {
      Provider.of<ReminderController>(context, listen: false).addReminder(
        _titleController.text,
        _descriptionController.text,
        _selectedDateTime!,
      );
      _titleController.clear();
      _descriptionController.clear();
      _selectedDateTime = null;
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields and select a time.")),
      );
    }
  }

  void _showAddReminderDialog() {
    // Clear controllers before showing dialog.
    _titleController.clear();
    _descriptionController.clear();
    _selectedDateTime = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Reminder"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: const Text("Pick Date & Time"),
              ),
              if (_selectedDateTime != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("Selected: ${_selectedDateTime.toString()}"),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _titleController.clear();
                _descriptionController.clear();
                _selectedDateTime = null;
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders")),
      body: Consumer<ReminderController>(
        builder: (context, controller, child) {
          return ListView.builder(
            itemCount: controller.reminders.length,
            itemBuilder: (context, index) {
              var reminder = controller.reminders[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reminder.description),
                    Text(reminder.reminderTime.toString()),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteReminder(reminder.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
