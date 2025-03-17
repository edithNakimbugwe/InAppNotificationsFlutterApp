import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/services/api_service.dart';
import 'package:reminder_app/services/notification_service.dart';

class ReminderController with ChangeNotifier {
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  Future<void> fetchReminders() async {
    _reminders = await ApiService.getReminders();
    notifyListeners();
  }

  Future<void> addReminder(String title, String description, DateTime reminderTime) async {
    final newReminder = Reminder(
      title: title,
      description: description,
      reminderTime: reminderTime,
    );

    await ApiService.addReminder(newReminder);
    await fetchReminders();

    // ✅ Schedule notification for the new reminder
    await NotificationService().scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      title: title,
      body: description,
      scheduledNotificationDateTime: reminderTime,
    );
  }

  Future<void> deleteReminder(int id) async {
    await ApiService.deleteReminder(id);
    await fetchReminders();
  }
}
