// To parse this JSON data, do
//
//     final studentHistoryModel = studentHistoryModelFromJson(jsonString);

import 'dart:convert';

StudentHistoryModel studentHistoryModelFromJson(String str) =>
    StudentHistoryModel.fromJson(json.decode(str));

String studentHistoryModelToJson(StudentHistoryModel data) =>
    json.encode(data.toJson());

class StudentHistoryModel {
  StudentHistoryModel({
    this.historyId,
    this.studentId,
    this.remark,
    this.feesAmount,
    this.addedDate,
  });

  int historyId;
  int studentId;
  String remark;
  double feesAmount;
  DateTime addedDate;

  factory StudentHistoryModel.fromJson(Map<String, dynamic> json) =>
      StudentHistoryModel(
        historyId: json["history_id"],
        studentId: json["student_id"],
        remark: json["remark"],
        feesAmount: json["fees_amount"].toDouble(),
        addedDate: DateTime.parse(json["added_date"]),
      );

  Map<String, dynamic> toJson() => {
        "history_id": historyId,
        "student_id": studentId,
        "remark": remark,
        "fees_amount": feesAmount,
        "added_date": addedDate.toIso8601String(),
      };
}
