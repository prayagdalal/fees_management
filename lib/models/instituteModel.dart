// To parse this JSON data, do
//
//     final instituteModel = instituteModelFromJson(jsonString);

import 'dart:convert';

InstituteModel instituteModelFromJson(String str) =>
    InstituteModel.fromJson(json.decode(str));

String instituteModelToJson(InstituteModel data) => json.encode(data.toJson());

class InstituteModel {
  InstituteModel({
    this.instituteId,
    this.instituteName,
    this.address,
    this.contactNo,
    this.emailId,
    this.websiteUrl,
    this.contactPerson,
    this.instituteDescription,
    this.addedDate,
    this.modifyDate,
  });

  int instituteId;
  String instituteName;
  String address;
  int contactNo;
  String emailId;
  String websiteUrl;
  String contactPerson;
  String instituteDescription;
  DateTime addedDate;
  DateTime modifyDate;

  factory InstituteModel.fromJson(Map<String, dynamic> json) => InstituteModel(
        instituteId: json["institute_id"],
        instituteName: json["institute_name"],
        address: json["address"],
        contactNo: json["contact_no"],
        emailId: json["email_id"],
        websiteUrl: json["website_url"],
        contactPerson: json["contact_person"],
        instituteDescription: json["institute_description"],
        addedDate: DateTime.parse(json["added_date"]),
        modifyDate: DateTime.parse(json["modify_date"]),
      );

  Map<String, dynamic> toJson() => {
        "institute_id": instituteId,
        "institute_name": instituteName,
        "address": address,
        "contact_no": contactNo,
        "email_id": emailId,
        "website_url": websiteUrl,
        "contact_person": contactPerson,
        "institute_description": instituteDescription,
        "added_date": addedDate.toIso8601String(),
        "modify_date": modifyDate.toIso8601String(),
      };
}
