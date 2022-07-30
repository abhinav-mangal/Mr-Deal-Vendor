import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/home_module/home_model.dart';
import 'package:mr_deal_app/login_module/login_model.dart';
import 'package:mr_deal_app/login_module/otp_module/otp_model.dart';
import 'package:mr_deal_app/login_module/register_module/register_model.dart';
import 'package:mr_deal_app/profile_module/delete_acc/delete_acc_model.dart';
import 'package:mr_deal_app/profile_module/edit_profile/editing_profile_module/edit_model.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_model.dart';
import 'package:mr_deal_app/wallet_module/wallet_model.dart';
import '../deactive_user.dart';
import 'deal_constant.dart';

class Apiconfig {
  static var timeoutrespon = {"status": false, "message": "timeout"};

  static Future<dynamic> postAPITyp(url, [header, params]) async {
    print('post');
    print(header);
    print(json.encode(params));
    print(url);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
            headers: header,
          )
          .timeout(const Duration(seconds: 20));
      print('DATA------>>');
      print(response.body);
      if (response.statusCode == 200) {}
      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      print('Timeout $e');
      return timeoutrespon;
    } on SocketException catch (e) {
      print('socketeee: $e');
      return timeoutrespon;
    } on Error catch (e) {
      print("in catch--");
      print('Error: $e');
    }
  }

  static Future<dynamic> getMethod(url, [header]) async {
    print(url);
    try {
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: header,
          )
          .timeout(const Duration(seconds: 20));

      final statusCode = response.statusCode;
      if (statusCode != 200 || response.body == null) {
        throw TimeoutException(
            'An error ocurred : [Status Code : $statusCode]');
      }
      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      print('Timeout $e');
      return timeoutrespon;
    } on SocketException catch (e) {
      print(e);
      return timeoutrespon;
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  Future<ContactVerifyModel> verifyContactApi(
      http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/contact-verify', header, request);
    print('response === $response');
    ContactVerifyModel data = ContactVerifyModel.fromMap(response);
    return data;
  }

  Future<OtpVerifyModel> verifyOtpApi(http.Client client, request, code) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/contact-verify?code=$code',
        header,
        request);
    print('response === $response');
    OtpVerifyModel data = OtpVerifyModel.fromMap(response);
    return data;
  }

  Future<RegisterModel> registerApi(http.Client client, request) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/register', header, request);
    print('response === $response');
    RegisterModel data = RegisterModel.fromMap(response);
    return data;
  }

  Future<VendorsModel> profileAPi(http.Client client, contact, context) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response =
        await getMethod(Constants.BASE_URL + 'vendor/$contact', header);
    print('response === $response');
    VendorsModel data = VendorsModel.fromMap(response);
    if (data.statuscode == 404) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DeactivatedUser()));

      return data;
    } else {
      return data;
    }
  }

  Future<EditProfileModel> editProfileAPi(
      http.Client client, request, context) async {
    var header = {
      "Content-Type": "application/json",
    };
    print('#@@@@@@@@@@@@@@');
    print(request);
    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/update/${MrDealGlobals.userContact}',
        header,
        request);
    print('response === $response');
    EditProfileModel data = EditProfileModel.fromMap(response);

    if (data.statuscode == 404) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DeactivatedUser()));

      return data;
    } else {
      return data;
    }
  }

  Future<WalletModel> walletApi(http.Client client, request, context) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/bookings', header, request);
    print('response === $response');
    WalletModel data = WalletModel.fromMap(response);
    if (data.statuscode == 404) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DeactivatedUser()));

      return data;
    } else {
      return data;
    }
  }

  Future<HomepageModel> homepageApi(http.Client client, context) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await getMethod(
        Constants.BASE_URL +
            'vendor/models/homepage/${MrDealGlobals.userContact}',
        header);
    print('hp response === $response');
    HomepageModel data = HomepageModel.fromMap(response);
    print('status code -- ${data.statuscode}');
    if (data.statuscode == 404) {
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DeactivatedUser()));

      return data;
    } else {
      return data;
    }
  }

  Future<DeleteUserModel> deleteAccApi(http.Client client) async {
    var header = {
      "Content-Type": "application/json",
    };

    final response = await postAPITyp(
        Constants.BASE_URL + 'vendor/delete/${MrDealGlobals.userContact}',
        header, {});
    print(response);
    DeleteUserModel data = DeleteUserModel.fromMap(response);
    return data;
  }
}
