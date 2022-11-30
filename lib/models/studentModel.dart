// To parse this JSON data, do
//
//     final studentModel = studentModelFromJson(jsonString);

import 'dart:convert';

StudentModel studentModelFromJson(String str) =>
    StudentModel.fromJson(json.decode(str));

String studentModelToJson(StudentModel data) => json.encode(data.toJson());

class StudentModel {
  StudentModel({
    this.studentId,
    this.studentCode,
    this.studentName,
    this.parentName,
    this.parentMobile,
    this.address,
    this.studentPhoto,
    this.groupId,
    this.batchId,
    this.feesAmount,
    this.totalFeesPaid,
    this.joinedDate,
    this.remark,
    this.status,
    this.instituteId,
    this.addedDate,
    this.modifyDate,
    this.isDeleted,
  });

  int studentId;
  int studentCode;
  String studentName;
  String parentName;
  int parentMobile;
  String address;
  String studentPhoto;
  int groupId;
  int batchId;
  double feesAmount;
  double totalFeesPaid;
  DateTime joinedDate;
  String remark;
  String status;
  int instituteId;
  DateTime addedDate;
  DateTime modifyDate;
  int isDeleted;

  bool getHasImage() {
    return this.studentPhoto != null && this.studentPhoto.isNotEmpty;
  }

  String getPhotoPath(String appDir) {
    if (this.studentPhoto == null || this.studentPhoto.isEmpty) {
      return '';
    }
    return appDir + this.studentPhoto;
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) => StudentModel(
        studentId: json["student_id"],
        studentCode: json["student_code"],
        studentName: json["student_name"],
        parentName: json["parent_name"],
        parentMobile: json["parent_mobile"],
        address: json["address"],
        studentPhoto: json["student_photo"],
        groupId: json["group_id"],
        batchId: json["batch_id"],
        feesAmount: json["fees_amount"].toDouble(),
        totalFeesPaid: json["total_fees_paid"].toDouble(),
        joinedDate: DateTime.parse(json["joined_date"]),
        remark: json["remark"],
        status: json["status"],
        instituteId: json["institute_id"],
        addedDate: DateTime.parse(json["added_date"]),
        modifyDate: DateTime.parse(json["modify_date"]),
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "student_code": studentCode,
        "student_name": studentName,
        "parent_name": parentName,
        "parent_mobile": parentMobile,
        "address": address,
        "student_photo": studentPhoto,
        "group_id": groupId,
        "batch_id": batchId,
        "fees_amount": feesAmount,
        "total_fees_paid": totalFeesPaid,
        "joined_date": joinedDate.toIso8601String(),
        "remark": remark,
        "status": status,
        "institute_id": instituteId,
        "added_date": addedDate.toIso8601String(),
        "modify_date": modifyDate.toIso8601String(),
        "is_deleted": isDeleted,
      };
}
