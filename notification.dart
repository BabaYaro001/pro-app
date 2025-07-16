class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final String recipient; // All/Role/Username
  final String timestamp; // ISO string

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.recipient,
    required this.timestamp,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) => NotificationModel(
        id: map['id'],
        title: map['title'],
        body: map['body'],
        recipient: map['recipient'],
        timestamp: map['timestamp'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'recipient': recipient,
        'timestamp': timestamp,
      };
}