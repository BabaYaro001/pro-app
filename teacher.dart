class Teacher {
  final int? id;
  final String username;
  final String password;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String section;
  final String className;
  final String education;
  final String photoPath;

  Teacher({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.section,
    required this.className,
    required this.education,
    required this.photoPath,
  });

  factory Teacher.fromMap(Map<String, dynamic> map) => Teacher(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        name: map['name'],
        address: map['address'],
        phone: map['phone'],
        email: map['email'],
        section: map['section'],
        className: map['className'],
        education: map['education'],
        photoPath: map['photoPath'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
        'section': section,
        'className': className,
        'education': education,
        'photoPath': photoPath,
      };
}