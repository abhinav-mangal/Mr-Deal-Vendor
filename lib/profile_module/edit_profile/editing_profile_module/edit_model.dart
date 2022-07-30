// To parse this JSON data, do
//
//     final editProfileModel = editProfileModelFromMap(jsonString);

import 'dart:convert';

EditProfileModel editProfileModelFromMap(String str) =>
    EditProfileModel.fromMap(json.decode(str));

String editProfileModelToMap(EditProfileModel data) =>
    json.encode(data.toMap());

class EditProfileModel {
  EditProfileModel({
    this.status,
    this.message,
    this.statuscode,
  });

  bool? status;
  String? message;
  int? statuscode;

  factory EditProfileModel.fromMap(Map<String, dynamic> json) =>
      EditProfileModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statuscode: json["statuscode"] == null ? null : json["statuscode"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "statuscode": statuscode == null ? null : statuscode,
      };
}
