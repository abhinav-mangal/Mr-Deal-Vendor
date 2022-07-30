// To parse this JSON data, do
//
//     final registerModel = registerModelFromMap(jsonString);

import 'dart:convert';

RegisterModel registerModelFromMap(String str) =>
    RegisterModel.fromMap(json.decode(str));

String registerModelToMap(RegisterModel data) => json.encode(data.toMap());

class RegisterModel {
  RegisterModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory RegisterModel.fromMap(Map<String, dynamic> json) => RegisterModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
      };
}
