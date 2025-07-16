class Club {
  final int? id;
  final String name;
  final String description;
  final String facultyAdvisor;
  final String meetingTime;
  final String category; // e.g., Sports, Science, Arts

  Club({
    this.id,
    required this.name,
    required this.description,
    required this.facultyAdvisor,
    required this.meetingTime,
    required this.category,
  });

  factory Club.fromMap(Map<String, dynamic> map) => Club(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        facultyAdvisor: map['facultyAdvisor'],
        meetingTime: map['meetingTime'],
        category: map['category'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'facultyAdvisor': facultyAdvisor,
        'meetingTime': meetingTime,
        'category': category,
      };
}