import 'package:flutter/material.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/services/notification_service.dart';

class ReminderController with ChangeNotifier {
  List<Reminder> _reminders = [];
  List<Reminder> get reminders => _reminders;

  Future<void> fetchReminders() async {
    _reminders = await ApiService.getReminders();
    notifyListeners();
  }

  Future<void> addReminder(String title, DateTime dateTime) async {
    final newReminder = Reminder(title: title, dateTime: dateTime);
    await ApiService.addReminder(newReminder);
    await fetchReminders();
  }

  Future<void> deleteReminder(int id) async {
    await ApiService.deleteReminder(id);
    await fetchReminders();
  }
}
