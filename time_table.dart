class TimetableEntry {
  final int? id;
  final String className;
  final String section;
  final String day;
  final String period;
  final String subject;
  final String teacher;

  TimetableEntry({
    this.id,
    required this.className,
    required this.section,
    required this.day,
    required this.period,
    required this.subject,
    required this.teacher,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> map) => TimetableEntry(
        id: map['id'],
        className: map['className'],
        section: map['section'],
        day: map['day'],
        period: map['period'],
        subject: map['subject'],
        teacher: map['teacher'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'className': className,
        'section': section,
        'day': day,
        'period': period,
        'subject': subject,
        'teacher': teacher,
      };
}