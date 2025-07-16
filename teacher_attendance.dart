class TeacherAttendance {
  final int? id;
  final String teacherName;
  final String teacherId;
  final String date;
  final String time;
  final String status;     // Present, Absent, Late, Excused
  final String location;   // "lat,lon" as a string

  TeacherAttendance({
    this.id,
    required this.teacherName,
    required this.teacherId,
    required this.date,
    required this.time,
    required this.status,
    required this.location,
  });

  factory TeacherAttendance.fromMap(Map<String, dynamic> map) => TeacherAttendance(
        id: map['id'],
        teacherName: map['teacherName'],
        teacherId: map['teacherId'],
        date: map['date'],
        time: map['time'],
        status: map['status'],
        location: map['location'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'teacherName': teacherName,
        'teacherId': teacherId,
        'date': date,
        'time': time,
        'status': status,
        'location': location,
      };
}