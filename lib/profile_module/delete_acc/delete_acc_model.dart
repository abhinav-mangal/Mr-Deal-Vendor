// To parse this JSON data, do
//
//     final deleteUserModel = deleteUserModelFromMap(jsonString);

import 'dart:convert';

DeleteUserModel deleteUserModelFromMap(String str) =>
    DeleteUserModel.fromMap(json.decode(str));

String deleteUserModelToMap(DeleteUserModel data) => json.encode(data.toMap());

class DeleteUserModel {
  DeleteUserModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory DeleteUserModel.fromMap(Map<String, dynamic> json) => DeleteUserModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
