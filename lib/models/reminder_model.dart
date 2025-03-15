class Reminder {
  final int? id;
  final String title;
  final DateTime dateTime;

  Reminder({this.id, required this.title, required this.dateTime});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
