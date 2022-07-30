// To parse this JSON data, do
//
//     final walletModel = walletModelFromMap(jsonString);

import 'dart:convert';

WalletModel walletModelFromMap(String str) =>
    WalletModel.fromMap(json.decode(str));

String walletModelToMap(WalletModel data) => json.encode(data.toMap());

class WalletModel {
  WalletModel({
    this.status,
    this.message,
    this.data,
    this.statuscode,
  });

  bool? status;
  String? message;
  List<Datum>? data;
  int? statuscode;

  factory WalletModel.fromMap(Map<String, dynamic> json) => WalletModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        statuscode: json["statuscode"] == null ? null : json["statuscode"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "statuscode": statuscode == null ? null : statuscode,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toMap())),
      };
}

class Datum {
  Datum({
    this.id,
    this.userContact,
    this.vendorContact,
    this.modelId,
    this.bookingStatus,
    this.pointsDeducted,
    this.repairStatus,
    this.createdTime,
    this.userDetails,
    this.shopDetails,
    this.warrantyDays,
    this.warrantyMonthly,
    this.price,
    this.paymentLinkId,
    this.paymentLink,
    this.shopClosed,
    this.bookingId,
    this.brand,
    this.editedTime,
  });

  String? id;
  String? userContact;
  String? vendorContact;
  String? modelId;
  String? bookingStatus;
  int? pointsDeducted;
  String? repairStatus;
  int? createdTime;
  UserDetails? userDetails;
  ShopDetails? shopDetails;
  bool? warrantyDays;
  bool? warrantyMonthly;
  int? price;
  String? paymentLinkId;
  String? paymentLink;
  bool? shopClosed;
  String? brand;
  String? bookingId;
  String? editedTime;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["_id"] == null ? null : json["_id"],
        userContact: json["user_contact"] == null ? null : json["user_contact"],
        vendorContact:
            json["vendor_contact"] == null ? null : json["vendor_contact"],
        modelId: json["model_id"] == null ? null : json["model_id"],
        bookingStatus:
            json["booking_status"] == null ? null : json["booking_status"],
        pointsDeducted:
            json["points_deducted"] == null ? null : json["points_deducted"],
        repairStatus:
            json["repair_status"] == null ? null : json["repair_status"],
        createdTime: json["created_time"] == null ? null : json["created_time"],
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromMap(json["user_details"]),
        shopDetails: json["shop_details"] == null
            ? null
            : ShopDetails.fromMap(json["shop_details"]),
        warrantyDays:
            json["warranty_days"] == null ? null : json["warranty_days"],
        warrantyMonthly:
            json["warranty_monthly"] == null ? null : json["warranty_monthly"],
        price: json["price"] == null ? null : json["price"],
        paymentLinkId:
            json["paymentLinkId"] == null ? null : json["paymentLinkId"],
        paymentLink: json["paymentLink"] == null ? null : json["paymentLink"],
        shopClosed: json["shop_closed"] == null ? null : json["shop_closed"],
        brand: json["brand"] == null ? null : json["brand"],
        bookingId:
            json["booking_id"] == null ? null : json["booking_id"].toString(),
        editedTime:
            json["edited_time"] == null ? null : json["edited_time"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "user_contact": userContact == null ? null : userContact,
        "vendor_contact": vendorContact == null ? null : vendorContact,
        "model_id": modelId == null ? null : modelId,
        "booking_status": bookingStatus == null ? null : bookingStatus,
        "points_deducted": pointsDeducted == null ? null : pointsDeducted,
        "repair_status": repairStatus == null ? null : repairStatus,
        "created_time": createdTime == null ? null : createdTime,
        "user_details": userDetails == null ? null : userDetails!.toMap(),
        "shop_details": shopDetails == null ? null : shopDetails!.toMap(),
        "warranty_days": warrantyDays == null ? null : warrantyDays,
        "warranty_monthly": warrantyMonthly == null ? null : warrantyMonthly,
        "price": price == null ? null : price,
        "paymentLinkId": paymentLinkId == null ? null : paymentLinkId,
        "paymentLink": paymentLink == null ? null : paymentLink,
        "shop_closed": shopClosed == null ? null : shopClosed,
      };
}

class ShopDetails {
  ShopDetails({
    this.id,
    this.contact,
    this.address,
    this.isRegistered,
    this.lat,
    this.long,
    this.ownerName,
    this.points,
    this.shopName,
    this.modifiedTime,
    this.distance,
  });

  String? id;
  String? contact;
  String? address;
  bool? isRegistered;
  String? lat;
  String? long;
  String? ownerName;
  int? points;
  String? shopName;
  int? modifiedTime;
  int? distance;

  factory ShopDetails.fromMap(Map<String, dynamic> json) => ShopDetails(
        id: json["_id"] == null ? null : json["_id"],
        contact: json["contact"] == null ? null : json["contact"],
        address: json["address"] == null ? null : json["address"],
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        ownerName: json["owner_name"] == null ? null : json["owner_name"],
        points: json["points"] == null ? null : json["points"],
        shopName: json["shop_name"] == null ? null : json["shop_name"],
        modifiedTime:
            json["modified_time"] == null ? null : json["modified_time"],
        distance: json["distance"] == null ? null : json["distance"],
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
        "shop_name": shopName == null ? null : shopName,
        "modified_time": modifiedTime == null ? null : modifiedTime,
        "distance": distance == null ? null : distance,
      };
}

class UserDetails {
  UserDetails({
    this.id,
    this.name,
    this.email,
    this.dob,
    this.contact,
    this.isRegistered,
    this.points,
  });

  String? id;
  String? name;
  String? email;
  String? dob;
  String? contact;
  bool? isRegistered;
  int? points;

  factory UserDetails.fromMap(Map<String, dynamic> json) => UserDetails(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        dob: json["dob"] == null ? null : json["dob"],
        contact: json["contact"] == null ? null : json["contact"],
        isRegistered:
            json["is_registered"] == null ? null : json["is_registered"],
        points: json["points"] == null ? null : json["points"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "dob": dob == null ? null : dob,
        "contact": contact == null ? null : contact,
        "is_registered": isRegistered == null ? null : isRegistered,
        "points": points == null ? null : points,
      };
}
