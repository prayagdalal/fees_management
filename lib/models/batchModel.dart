// To parse this JSON data, do
//
//     final batchModel = batchModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

BatchModel batchModelFromJson(String str) =>
    BatchModel.fromJson(json.decode(str));

String batchModelToJson(BatchModel data) => json.encode(data.toJson());

final DateFormat formatter = DateFormat('dd MMM');

class BatchModel {
  BatchModel(
      {this.batchId,
      this.batchName,
      this.startDate,
      this.endDate,
      this.days,
      this.type,
      this.subject,
      this.defaultFeesAmount});

  int batchId;
  String batchName;
  DateTime startDate;
  DateTime endDate;
  int days;
  String type;
  String subject;
  double defaultFeesAmount;

  getStartDate() {
    if (this.startDate != null) return formatter.format(this.startDate);
    return "--";
  }

  getEndDate() {
    if (this.endDate != null) return formatter.format(this.endDate);
    return "--";
  }

  factory BatchModel.fromJson(Map<String, dynamic> json) => BatchModel(
        batchId: json["batch_id"],
        batchName: json["batch_name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        days: json["days"],
        type: json["type"],
        subject: json["subject"],
        defaultFeesAmount: json["default_fees_amount"],
      );

  Map<String, dynamic> toJson() => {
        "batch_id": batchId,
        "batch_name": batchName,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "days": days,
        "type": type,
        "subject": subject,
        "default_fees_amount": defaultFeesAmount,
      };
}
