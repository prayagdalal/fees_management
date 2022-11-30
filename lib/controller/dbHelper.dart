import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/batchModel.dart';
import '../models/instituteModel.dart';
import '../models/studentHistoryModel.dart';
import '../models/studentModel.dart';

class DBProvider {
  DBProvider._();
  String path;
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    path = join(documentDirectory.path, 'feesDB1.db');

    var db = await openDatabase(path, version: 1, onOpen: _onCreate);
    return db;
  }

  _onCreate(Database db) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS groupTbl (group_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , group_name TEXT NOT NULL, default_fees_amount DOUBLE DEFAULT "0" NOT NULL)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS batchTbl (batch_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, batch_name TEXT NOT NULL, start_date DATETIME, end_date DATETIME, days INTEGER NOT NULL DEFAULT 0, type TEXT NOT NULL, subject TEXT,default_fees_amount DOUBLE NOT NULL)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS instituteTbl (institute_id INTEGER PRIMARY KEY AUTOINCREMENT, institute_name TEXT NOT NULL, address TEXT, contact_no INTEGER NOT NULL, email_id  TEXT, website_url  TEXT, contact_person  TEXT,institute_description TEXT, added_date DATETIME, modify_date DATETIME)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS studentTbl (student_id  INTEGER PRIMARY KEY AUTOINCREMENT, student_code INTEGER NOT NULL, student_name TEXT NOT NULL, parent_name TEXT, parent_mobile  INTEGER, address TEXT, student_photo TEXT, group_id INTEGER, batch_id INTEGER, fees_amount DOUBLE NOT NULL, total_fees_paid DOUBLE DEFAULT "0" NOT NULL, joined_date DATETIME NOT NULL, remark  TEXT, status TEXT NOT NULL, institute_id INTEGER, added_date DATETIME NOT NULL, modify_date DATETIME NOT NULL, is_deleted INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS studentHistoryTbl (history_id INTEGER PRIMARY KEY AUTOINCREMENT,student_id INTEGER NOT NULL, remark TEXT NOT NULL, fees_amount DOUBLE DEFAULT "0" NOT NULL, added_date DATETIME NOT NULL)');
  }

  deleteTbl() async {
    final db = await database;

    // db.execute("DROP TABLE groupTbl");
    db.execute("DROP TABLE studentHistoryTbl");
  }

  // deletedb() async {
  //   await deleteDatabase(path);
  // }

  deleteGroup(int id) async {
    final db = await database;
    return db.delete("groupTbl", where: "group_id = ?", whereArgs: [id]);
  }

// CRUD BATCHES

  Future<BatchModel> addBatch(BatchModel batch) async {
    final db = await database;
    await db.insert('batchTbl', batch.toJson());
  }

  Future<List<BatchModel>> getBatches() async {
    final db = await database;
    var res = await db.query("batchTbl");

    List<BatchModel> list =
        res.isNotEmpty ? res.map((c) => BatchModel.fromJson(c)).toList() : [];

    return list;
  }

  deleteBatch(int id) async {
    final db = await database;
    return db.delete("batchTbl", where: "batch_id = ?", whereArgs: [id]);
  }

  updateBatch(BatchModel newBatch) async {
    final db = await database;
    var res = db.update("batchTbl", newBatch.toJson(),
        where: "batch_id=?", whereArgs: [newBatch.batchId]);
    return res;
  }

  //CRUD INSTITUTE

  Future<InstituteModel> addInstitute(InstituteModel institute) async {
    final db = await database;
    await db.insert('instituteTbl', institute.toJson());
  }

  Future<List<InstituteModel>> getInstitute() async {
    final db = await database;
    var res = await db.query("instituteTbl");

    List<InstituteModel> list = res.isNotEmpty
        ? res.map((c) => InstituteModel.fromJson(c)).toList()
        : [];

    return list;
  }

  deleteInstitute(int id) async {
    final db = await database;
    return db
        .delete("instituteTbl", where: "institute_id = ?", whereArgs: [id]);
  }

  updateInstitute(InstituteModel newInstitute) async {
    final db = await database;
    var res = db.update("instituteTbl", newInstitute.toJson(),
        where: "institute_id=?", whereArgs: [newInstitute.instituteId]);
    return res;
  }

  //CRUD STUDENT

  Future<StudentModel> addStudent(StudentModel student) async {
    final db = await database;
    await db.insert('studentTbl', student.toJson());
  }

  Future<List<StudentModel>> getStudent({batchId = 0}) async {
    final db = await database;
    // var res;

    if (batchId > 0) {
      var res = await db
          .query("studentTbl", where: 'batch_id = ?', whereArgs: [batchId]);
      List<StudentModel> list = res.isNotEmpty
          ? res.map((c) => StudentModel.fromJson(c)).toList()
          : [];
      return list;
    } else {
      var res = await db.query("studentTbl");
      List<StudentModel> list = res.isNotEmpty
          ? res.map((c) => StudentModel.fromJson(c)).toList()
          : [];
      return list;
    }
  }

  Future<StudentModel> getStudentDetail(int studentId) async {
    final db = await database;
    var res = await db
        .query("studentTbl", where: 'student_id = ?', whereArgs: [studentId]);

    List<StudentModel> list =
        res.isNotEmpty ? res.map((c) => StudentModel.fromJson(c)).toList() : [];
    if (list.length == 0) return new StudentModel();

    return list[0];
  }

  deleteStudent(int id) async {
    final db = await database;
    return db.delete("studentTbl", where: "student_id = ?", whereArgs: [id]);
  }

  deleteStudentHistory(int id) async {
    final db = await database;
    return db
        .delete("studentHistoryTbl", where: "student_id = ?", whereArgs: [id]);
  }

  deleteStudentByBatch(int id) async {
    final db = await database;
    return db.delete("studentTbl", where: "batch_id = ?", whereArgs: [id]);
  }

  updateStudent(StudentModel newStudent) async {
    final db = await database;
    var res = db.update("studentTbl", newStudent.toJson(),
        where: "student_id=?", whereArgs: [newStudent.studentId]);
    return res;
  }

  updateStudentHistorytable(StudentHistoryModel newStudent) async {
    final db = await database;
    var res = db.update("studentHistoryTbl", newStudent.toJson(),
        where: "history_id=?", whereArgs: [newStudent.historyId]);
    return res;
  }

  //CRUD STUDENT HISTORY TABLE
  Future<StudentHistoryModel> addStudentFees(
      StudentHistoryModel studentHistory) async {
    final db = await database;
    await db.insert('studentHistoryTbl', studentHistory.toJson());
  }

  Future<List<StudentHistoryModel>> getHistory(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "Select * from studentHistoryTbl where student_id='" +
            id.toString() +
            "' ORDER BY added_date DESC");

    List<StudentHistoryModel> list = res.isNotEmpty
        ? res.map((c) => StudentHistoryModel.fromJson(c)).toList()
        : [];
    return list;
  }

  getCount(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(*) as totalStudents FROM studentTbl where student_id=" +
            id.toString());

    return res;
  }

  getCountInstitute(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(*) as totalInstitute FROM instituteTbl where institute_id=" +
            id.toString());

    return res;
  }

  getCountGroup(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(*) as totalGroup FROM groupTbl where group_id=" +
            id.toString());

    return res;
  }

  getCountBatches(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT COUNT(*) as totalBatch FROM batchTbl where batch_id=" +
            id.toString());

    return res;
  }

  getSum(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT SUM(fees_amount) as paid FROM studentHistoryTbl where student_id=" +
            id.toString());

    return res;
  }

  getLastId() async {
    final db = await database;

    var res = await db.rawQuery(
        "SELECT student_id  FROM studentTbl WHERE student_id = (SELECT MAX(student_id)  FROM studentTbl)");

    return res;
  }

  getSumByBatch() async {
    final db = await database;
    var res =
        await db.rawQuery("SELECT SUM(fees_amount) as total FROM studentTbl");

    return res;
  }

  getRecivedFees() async {
    final db = await database;
    var res = await db
        .rawQuery("SELECT SUM(fees_amount) as received FROM studentHistoryTbl");

    return res;
  }

  deleteRecord(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "delete from studentHistoryTbl where history_id=" + id.toString());

    return res;
  }

  deleteRecordByStudentid(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        'delete from studentHistoryTbl where student_id IN (SELECT student_id FROM studentTbl WHERE batch_id=' +
            id.toString() +
            ')');

    return res;
  }

  Future<int> getRollno(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT MAX(student_code) as rollno FROM studentTbl where batch_id=" +
            id.toString());
    var rollno = res.first["rollno"];

    if (rollno == null) return 1;

    return rollno + 1;
  }
}
