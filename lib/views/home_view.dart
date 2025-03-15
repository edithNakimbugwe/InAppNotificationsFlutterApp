import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/reminder_model.dart';
import '../controllers/reminder_controller.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    Provider.of<ReminderController>(context, listen: false).fetchReminders();
  }

  void _addReminder() {
    if (_titleController.text.isNotEmpty && _selectedDateTime != null) {
      Provider.of<ReminderController>(context, listen: false)
          .addReminder(_titleController.text, _selectedDateTime!);
      _titleController.clear();
      _selectedDateTime = null;
      Navigator.of(context).pop();
    }
  }

  void _showAddReminderDialog() {
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
              Reminder reminder = controller.reminders[index];
              return ListTile(
                title: Text(reminder.title),
                subtitle: Text(reminder.dateTime.toString()),
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
