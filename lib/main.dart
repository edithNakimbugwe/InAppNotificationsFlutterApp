import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/reminder_controller.dart';
import 'views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReminderController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Reminder App",
        home: HomeView(),
      ),
    );
  }
}
