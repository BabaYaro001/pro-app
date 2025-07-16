class Event {
  final int? id;
  final String title;
  final String description;
  final String date;
  final String location;
  final String organizer;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizer,
  });

  factory Event.fromMap(Map<String, dynamic> map) => Event(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        date: map['date'],
        location: map['location'],
        organizer: map['organizer'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'organizer': organizer,
      };
}