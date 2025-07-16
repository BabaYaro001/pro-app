class Message {
  final int? id;
  final String sender;    // e.g., "admin", "teacher", "parent", "student"
  final String recipient; // e.g., "All", "Teachers", "Parents", "Students", or specific username
  final String subject;
  final String content;
  final String timestamp; // ISO string

  Message({
    this.id,
    required this.sender,
    required this.recipient,
    required this.subject,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        id: map['id'],
        sender: map['sender'],
        recipient: map['recipient'],
        subject: map['subject'],
        content: map['content'],
        timestamp: map['timestamp'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'sender': sender,
        'recipient': recipient,
        'subject': subject,
        'content': content,
        'timestamp': timestamp,
      };
}