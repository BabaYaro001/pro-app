class Transport {
  final int? id;
  final String vehicleNumber;
  final String driverName;
  final String driverPhone;
  final String route;
  final String type; // e.g. Bus, Van, Car
  final String status; // Active, Maintenance, Inactive

  Transport({
    this.id,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverPhone,
    required this.route,
    required this.type,
    required this.status,
  });

  factory Transport.fromMap(Map<String, dynamic> map) => Transport(
        id: map['id'],
        vehicleNumber: map['vehicleNumber'],
        driverName: map['driverName'],
        driverPhone: map['driverPhone'],
        route: map['route'],
        type: map['type'],
        status: map['status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'vehicleNumber': vehicleNumber,
        'driverName': driverName,
        'driverPhone': driverPhone,
        'route': route,
        'type': type,
        'status': status,
      };
}