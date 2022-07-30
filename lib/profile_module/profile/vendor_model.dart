// To parse this JSON data, do
//
//     final vendorsModel = vendorsModelFromMap(jsonString);

import 'dart:convert';

VendorsModel vendorsModelFromMap(String str) =>
    VendorsModel.fromMap(json.decode(str));

String vendorsModelToMap(VendorsModel data) => json.encode(data.toMap());

class VendorsModel {
  VendorsModel({
    this.status,
    this.message,
    this.data,
    this.statuscode,
  });

  bool? status;
  String? message;
  Data? data;
  int? statuscode;

  factory VendorsModel.fromMap(Map<String, dynamic> json) => VendorsModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statuscode: json["statuscode"] == null ? null : json["statuscode"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "statuscode": statuscode == null ? null : statuscode,
        "data": data == null ? null : data!.toMap(),
      };
}

class Data {
  Data({
    this.id,
    this.contact,
    this.address,
    this.isRegistered,
    this.lat,
    this.long,
    this.ownerName,
    this.points,
    this.shopImage,
    this.shopName,
    this.modifiedTime,
  });

  String? id;
  String? contact;
  String? address;
  bool? isRegistered;
  String? lat;
  String? long;
  String? ownerName;
  int? points;
  String? shopImage;
  String? shopName;
  int? modifiedTime;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["_id"] == null ? null : json["_id"],
        contact: json["contact"] == null ? null : json["contact"],
        address: json["address"] == null ? null : json["address"],
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        ownerName: json["owner_name"] == null ? null : json["owner_name"],
        points: json["points"] == null ? null : json["points"],
        shopImage: json["shop_image"] == null ? null : json["shop_image"],
        shopName: json["shop_name"] == null ? null : json["shop_name"],
        modifiedTime:
            json["modified_time"] == null ? null : json["modified_time"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "contact": contact == null ? null : contact,
        "address": address == null ? null : address,
        "is_registered": isRegistered == null ? null : isRegistered,
        "lat": lat == null ? null : lat,
        "long": long == null ? null : long,
        "owner_name": ownerName == null ? null : ownerName,
        "points": points == null ? null : points,
        "shop_image": shopImage == null ? null : shopImage,
        "shop_name": shopName == null ? null : shopName,
        "modified_time": modifiedTime == null ? null : modifiedTime,
      };
}
