class Announcement {
  final int? id;
  final String title;
  final String content;
  final String date; // Store as ISO string (YYYY-MM-DD)
  final String author;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
  });

  factory Announcement.fromMap(Map<String, dynamic> map) => Announcement(
        id: map['id'],
        title: map['title'],
        content: map['content'],
        date: map['date'],
        author: map['author'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date,
        'author': author,
      };
}