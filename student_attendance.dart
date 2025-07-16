class StudentAttendance {
  final int? id;
  final String studentName;
  final String studentId;
  final String className;
  final String section;
  final String date;
  final String status;    // Present, Absent, Late, Excused
  final String takenBy;   // Teacher name or ID

  StudentAttendance({
    this.id,
    required this.studentName,
    required this.studentId,
    required this.className,
    required this.section,
    required this.date,
    required this.status,
    required this.takenBy,
  });

  factory StudentAttendance.fromMap(Map<String, dynamic> map) => StudentAttendance(
        id: map['id'],
        studentName: map['studentName'],
        studentId: map['studentId'],
        className: map['className'],
        section: map['section'],
        date: map['date'],
        status: map['status'],
        takenBy: map['takenBy'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'studentId': studentId,
        'className': className,
        'section': section,
        'date': date,
        'status': status,
        'takenBy': takenBy,
      };
}