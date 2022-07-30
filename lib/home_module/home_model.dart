// To parse this JSON data, do
//
//     final homepageModel = homepageModelFromMap(jsonString);

import 'dart:convert';

HomepageModel homepageModelFromMap(String str) =>
    HomepageModel.fromMap(json.decode(str));

String homepageModelToMap(HomepageModel data) => json.encode(data.toMap());

class HomepageModel {
  HomepageModel({
    this.status,
    this.message,
    this.data,
    this.statuscode,
  });

  bool? status;
  String? message;
  Data? data;
  int? statuscode;

  factory HomepageModel.fromMap(Map<String, dynamic> json) => HomepageModel(
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
    this.models,
    this.images,
  });

  List<DataModel>? models;
  List<ImageData>? images;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        models: json["models"] == null
            ? null
            : List<DataModel>.from(
                json["models"].map((x) => DataModel.fromMap(x))),
        images: json["images"] == null
            ? null
            : List<ImageData>.from(
                json["images"].map((x) => ImageData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "models": models == null
            ? null
            : List<dynamic>.from(models!.map((x) => x.toMap())),
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toMap())),
      };
}

class ImageData {
  ImageData({
    this.name,
    this.url,
  });

  String? name;
  String? url;

  factory ImageData.fromMap(Map<String, dynamic> json) => ImageData(
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "url": url == null ? null : url,
      };
}

class DataModel {
  DataModel({
    this.id,
    this.brandId,
    this.brand,
    this.series,
  });

  String? id;
  String? brandId;
  String? brand;
  List<Series>? series;

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json["_id"] == null ? null : json["_id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        brand: json["brand"] == null ? null : json["brand"],
        series: json["series"] == null
            ? null
            : List<Series>.from(json["series"].map((x) => Series.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "brand_id": brandId == null ? null : brandId,
        "brand": brand == null ? null : brand,
        "series": series == null
            ? null
            : List<dynamic>.from(series!.map((x) => x.toMap())),
      };
}

class Series {
  Series({
    this.seriesId,
    this.sName,
    this.model,
  });

  String? seriesId;
  String? sName;
  List<SeriesModel>? model;

  factory Series.fromMap(Map<String, dynamic> json) => Series(
        seriesId: json["series_id"] == null ? null : json["series_id"],
        sName: json["s_name"] == null ? null : json["s_name"],
        model: json["model"] == null
            ? null
            : List<SeriesModel>.from(
                json["model"].map((x) => SeriesModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "series_id": seriesId == null ? null : seriesId,
        "s_name": sName == null ? null : sName,
        "model": model == null
            ? null
            : List<dynamic>.from(model!.map((x) => x.toMap())),
      };
}

class SeriesModel {
  SeriesModel({
    this.modelId,
    this.mName,
    this.warrantyPriceDays,
    this.warrantyPriceMonthly,
    this.priceNormal,
    this.priceAmoled,
    this.imgUrl,
  });

  String? modelId;
  String? mName;
  int? warrantyPriceDays;
  int? warrantyPriceMonthly;
  int? priceNormal;
  int? priceAmoled;
  String? imgUrl;

  factory SeriesModel.fromMap(Map<String, dynamic> json) => SeriesModel(
        modelId: json["model_id"] == null ? null : json["model_id"],
        mName: json["m_name"] == null ? null : json["m_name"],
        warrantyPriceDays: json["warranty_price_days"] == null
            ? null
            : json["warranty_price_days"],
        warrantyPriceMonthly: json["warranty_price_monthly"] == null
            ? null
            : json["warranty_price_monthly"],
        priceNormal: json["price_normal"] == null ? null : json["price_normal"],
        priceAmoled: json["price_amoled"] == null ? null : json["price_amoled"],
        imgUrl: json["img_url"] == null ? null : json["img_url"],
      );

  Map<String, dynamic> toMap() => {
        "model_id": modelId == null ? null : modelId,
        "m_name": mName == null ? null : mName,
        "warranty_price_days":
            warrantyPriceDays == null ? null : warrantyPriceDays,
        "warranty_price_monthly":
            warrantyPriceMonthly == null ? null : warrantyPriceMonthly,
        "price_normal": priceNormal == null ? null : priceNormal,
        "price_amoled": priceAmoled == null ? null : priceAmoled,
        "img_url": imgUrl == null ? null : imgUrl,
      };
}
