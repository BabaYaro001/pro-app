class Fee {
  final int? id;
  final String studentName;
  final String className;
  final String section;
  final String type; // e.g., Tuition, Transport, etc.
  final double amount;
  final String dueDate;
  final String status; // Paid, Pending, Overdue

  Fee({
    this.id,
    required this.studentName,
    required this.className,
    required this.section,
    required this.type,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory Fee.fromMap(Map<String, dynamic> map) => Fee(
        id: map['id'],
        studentName: map['studentName'],
        className: map['className'],
        section: map['section'],
        type: map['type'],
        amount: map['amount'],
        dueDate: map['dueDate'],
        status: map['status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'className': className,
        'section': section,
        'type': type,
        'amount': amount,
        'dueDate': dueDate,
        'status': status,
      };
}