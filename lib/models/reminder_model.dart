class Reminder {
  final int? id;
  final String title;
  final String description;
  final DateTime reminderTime;

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.reminderTime,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      reminderTime: DateTime.parse(json['reminderTime']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'title': title,
      'description': description,
      'reminderTime': reminderTime.toIso8601String(),
    };
    // Only include 'id' if it's not null
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
