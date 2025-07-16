class Resource {
  final int? id;
  final String title;
  final String description;
  final String url;
  final String uploadedBy;
  final String uploadDate;

  Resource({
    this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.uploadedBy,
    required this.uploadDate,
  });

  factory Resource.fromMap(Map<String, dynamic> map) => Resource(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        url: map['url'],
        uploadedBy: map['uploadedBy'],
        uploadDate: map['uploadDate'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'uploadedBy': uploadedBy,
        'uploadDate': uploadDate,
      };
}