import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/teacher.dart';
import '../models/timetable.dart';
import '../models/cafeteria_item.dart';
import '../models/emergency_contact.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('school_management.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        section TEXT NOT NULL,
        className TEXT NOT NULL,
        education TEXT NOT NULL,
        photoPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender TEXT NOT NULL,
        dob TEXT NOT NULL,
        admissionDate TEXT NOT NULL,
        address TEXT NOT NULL,
        email TEXT NOT NULL,
        section TEXT NOT NULL,
        className TEXT NOT NULL,
        parentName TEXT NOT NULL,
        parentPhone TEXT NOT NULL,
        photoPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE parents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        address TEXT NOT NULL,
        studentName TEXT NOT NULL,
        studentClass TEXT NOT NULL,
        studentSection TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE timetable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        className TEXT NOT NULL,
        section TEXT NOT NULL,
        day TEXT NOT NULL,
        period TEXT NOT NULL,
        subject TEXT NOT NULL,
        teacher TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE announcement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date TEXT NOT NULL,
        author TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE event (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        location TEXT NOT NULL,
        organizer TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE resource (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        url TEXT NOT NULL,
        uploadedBy TEXT NOT NULL,
        uploadDate TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE fee (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentName TEXT NOT NULL,
        className TEXT NOT NULL,
        section TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        dueDate TEXT NOT NULL,
        status TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE cafeteria (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        available TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE club (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        facultyAdvisor TEXT NOT NULL,
        meetingTime TEXT NOT NULL,
        category TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE achievement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        studentName TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE emergency_contact (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        description TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE transport (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        vehicleNumber TEXT NOT NULL,
        driverName TEXT NOT NULL,
        driverPhone TEXT NOT NULL,
        route TEXT NOT NULL,
        type TEXT NOT NULL,
        status TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE message (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender TEXT NOT NULL,
        recipient TEXT NOT NULL,
        subject TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE notification (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        recipient TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE student_attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentName TEXT NOT NULL,
        studentId TEXT NOT NULL,
        className TEXT NOT NULL,
        section TEXT NOT NULL,
        date TEXT NOT NULL,
        status TEXT NOT NULL,
        takenBy TEXT NOT NULL
      );
    ''');
    await db.execute('''
      CREATE TABLE teacher_attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacherName TEXT NOT NULL,
        teacherId TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        status TEXT NOT NULL,
        location TEXT NOT NULL
      );
    ''');
  }

  // Implement CRUD methods here for each entity, as in your original file.
  // Example for Teacher:
  Future<int> insertTeacher(Teacher teacher) async {
    final db = await instance.database;
    return await db.insert('teachers', teacher.toMap());
  }

  Future<List<Teacher>> getAllTeachers() async {
    final db = await instance.database;
    final result = await db.query('teachers');
    return result.map((map) => Teacher.fromMap(map)).toList();
  }

  Future<int> updateTeacher(Teacher teacher) async {
    final db = await instance.database;
    return await db.update('teachers', teacher.toMap(),
        where: 'id = ?', whereArgs: [teacher.id]);
  }

  Future<int> deleteTeacher(int id) async {
    final db = await instance.database;
    return await db.delete('teachers', where: 'id = ?', whereArgs: [id]);
  }

  // ... repeat for other entities (students, parents, timetable, etc.)
}