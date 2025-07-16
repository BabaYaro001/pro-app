class Student {
  final int? id;
  final String name;
  final String gender;
  final String dob;
  final String admissionDate;
  final String address;
  final String email;
  final String section;
  final String className;
  final String parentName;
  final String parentPhone;
  final String photoPath;

  Student({
    this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.admissionDate,
    required this.address,
    required this.email,
    required this.section,
    required this.className,
    required this.parentName,
    required this.parentPhone,
    required this.photoPath,
  });

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['id'],
        name: map['name'],
        gender: map['gender'],
        dob: map['dob'],
        admissionDate: map['admissionDate'],
        address: map['address'],
        email: map['email'],
        section: map['section'],
        className: map['className'],
        parentName: map['parentName'],
        parentPhone: map['parentPhone'],
        photoPath: map['photoPath'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'gender': gender,
        'dob': dob,
        'admissionDate': admissionDate,
        'address': address,
        'email': email,
        'section': section,
        'className': className,
        'parentName': parentName,
        'parentPhone': parentPhone,
        'photoPath': photoPath,
      };
}