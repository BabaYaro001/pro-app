class Achievement {
  final int? id;
  final String title;
  final String description;
  final String studentName;
  final String date;
  final String type; // e.g. Academic, Sports, Arts

  Achievement({
    this.id,
    required this.title,
    required this.description,
    required this.studentName,
    required this.date,
    required this.type,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        studentName: map['studentName'],
        date: map['date'],
        type: map['type'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'studentName': studentName,
        'date': date,
        'type': type,
      };
}