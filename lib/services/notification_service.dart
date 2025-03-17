import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reminder_app/models/reminder_model.dart';

class ApiService {
  static const String baseUrl = "https://3a15-41-75-191-200.ngrok-free.app/api/reminders";

  static Future<List<Reminder>> getReminders() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Reminder.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load reminders");
    }
  }

  static Future<void> addReminder(Reminder reminder) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reminder.toJson()),
    );

    if (response.statusCode != 201) {
      print("Add reminder failed with status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Failed to add reminder");
    }
  }

  static Future<void> deleteReminder(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      print("Delete reminder failed with status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Failed to delete reminder");
    }
  }
}
