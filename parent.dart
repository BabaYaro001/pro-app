class Parent {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String studentName;
  final String studentClass;
  final String studentSection;

  Parent({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.studentName,
    required this.studentClass,
    required this.studentSection,
  });

  factory Parent.fromMap(Map<String, dynamic> map) => Parent(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'],
        address: map['address'],
        studentName: map['studentName'],
        studentClass: map['studentClass'],
        studentSection: map['studentSection'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'studentName': studentName,
        'studentClass': studentClass,
        'studentSection': studentSection,
      };
}