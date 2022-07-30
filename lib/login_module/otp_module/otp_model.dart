// To parse this JSON data, do
//
//     final otpVerifyModel = otpVerifyModelFromMap(jsonString);

import 'dart:convert';

OtpVerifyModel otpVerifyModelFromMap(String str) =>
    OtpVerifyModel.fromMap(json.decode(str));

String otpVerifyModelToMap(OtpVerifyModel data) => json.encode(data.toMap());

class OtpVerifyModel {
  OtpVerifyModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory OtpVerifyModel.fromMap(Map<String, dynamic> json) => OtpVerifyModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    this.isRegistered,
  });

  bool? isRegistered;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
      );

  Map<String, dynamic> toMap() => {
        "is_registered": isRegistered == null ? null : isRegistered,
      };
}
