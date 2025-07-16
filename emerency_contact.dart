class EmergencyContact {
  final int? id;
  final String name;
  final String role; // e.g. Principal, Nurse, Security, Local Police, etc.
  final String phone;
  final String email;
  final String description;

  EmergencyContact({
    this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.description,
  });

  factory EmergencyContact.fromMap(Map<String, dynamic> map) => EmergencyContact(
        id: map['id'],
        name: map['name'],
        role: map['role'],
        phone: map['phone'],
        email: map['email'],
        description: map['description'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'role': role,
        'phone': phone,
        'email': email,
        'description': description,
      };
}