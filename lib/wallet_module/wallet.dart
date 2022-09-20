import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/wallet_module/order_delivered.dart';
import 'package:mr_deal_app/wallet_module/wallet_model.dart';
import 'package:mr_deal_app/wallet_module/wallet_view.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart' as http;

import '../Utls/deal_constant.dart';
import 'wallet_presenter.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> implements WalletView {
  bool _isLoading = true;
  var noConnection;
  WalletModel? _walletModelResp;

  String? otp;

  bool visible = false;

  String _datetime(timestamp) {
    var dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var d12 = DateFormat('dd-MM-yyyy, hh:mm a').format(dt);

    return d12.toString();
  }

  Widget _body() {
    return Container(
      color: white_color,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const TextWidget(
              text: 'Transaction History',
              size: text_size_18,
              weight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            _isLoading
                ? const Center(
                    child: SizedBox(height: 500, child: Loader()),
                  )
                : _trxnHistry()
          ],
        ),
      ),
    );
  }

  Widget _trxnHistry() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 230,
      child: (_walletModelResp?.data?.length ?? 0) == 0
          ? const Center(
              child: TextWidget(
              text: 'No Transactions Found',
              size: text_size_18,
              weight: FontWeight.w600,
            ))
          : ListView.builder(
              itemCount: _walletModelResp?.data?.length ?? 0,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, i) {
                String warranty() {
                  if (_walletModelResp?.data![i].warrantyDays == true &&
                      _walletModelResp?.data![i].warrantyMonthly == true) {
                    return "10 days replacement warranty & 6 month functional warranty";
                  } else if (_walletModelResp?.data![i].warrantyMonthly ==
                          true &&
                      _walletModelResp?.data![i].warrantyDays == false) {
                    return "6 month functional warranty";
                  } else if (_walletModelResp?.data![i].warrantyDays == true &&
                      _walletModelResp?.data![i].warrantyMonthly == false) {
                    return "10 days replacement warranty";
                  } else {
                    return "N/A";
                  }
                }

                return GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AnswerPdfPage(
                    //               testNo: i + 1,
                    //               url: solutionsList![i].url,
                    //             )));
                  },
                  child: Container(
                      // height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                          color: white_color,
                          border: Border.all(color: shadow_color, width: 0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: transparent,
                            // padding: const EdgeInsets.only(bottom: 5),
                            width: MediaQuery.of(context).size.width - 110,
                            child: TextWidget(
                              text:
                                  'Booking ID: ${_walletModelResp?.data![i].bookingId ?? ''}',
                              size: text_size_14,
                              weight: FontWeight.w500,
                            ),
                          ),
                          TextWidget(
                            text:
                                'Name : ${_walletModelResp?.data![i].userDetails?.name ?? ''}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Contact No : ${_walletModelResp?.data![i].userDetails?.contact ?? ''}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Booked On : ${_datetime(_walletModelResp?.data![i].createdTime)}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Model Name & Make: ${_walletModelResp?.data![i].brand}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text: 'Warranty Status : ${warranty()}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text:
                                'Service Status : ${_walletModelResp?.data![i].bookingStatus}'
                                ' ${_walletModelResp?.data![i].editedTime ?? ''}',
                            size: text_size_14,
                            weight: FontWeight.w500,
                          ),
                          _walletModelResp?.data![i].bookingStatus == "Pending"
                              ? Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      enterOtp(
                                          vendorContact:
                                              "${_walletModelResp?.data![i].vendorContact}",
                                          bookingId:
                                              "${_walletModelResp?.data![i].bookingId}");
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                theme_color)),
                                    child: const Text("Confirm Order"),
                                  ),
                                )
                              : Container()
                        ],
                      )),
                );
              }),
    );
  }

  Future<void> enterOtp(
      {required String vendorContact, required String bookingId}) async {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            child: StatefulBuilder(
              builder: ((context, setState) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Enter OTP",
                        style: TextStyle(
                            fontSize: text_size_18,
                            color: theme_color,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(color: theme_color),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              cursorColor: theme_color,
                              cursorHeight: 10,
                              pinTheme: const PinTheme.defaults(
                                fieldWidth: 20,
                                fieldHeight: 30,
                                activeColor: theme_color,
                                inactiveColor: theme_color,
                                selectedColor: theme_color,
                              ),
                              onChanged: (value) {
                                otp = value;
                              },
                              // onCompleted: (value) {
                              //   Navigator.pop(context);
                              // },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Visibility(
                          visible: visible,
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Please enter corrct OTP. The entered OTP does not match with the OTP shared with the MR DEAL customer",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: theme_color, width: 0.3),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red[50]),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "PLEASE ASK MR DEAL CUSTOMER TO SHARE OTP AT THE TIME OF COLLECTING DEVICE.",
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await otpVerify(
                                  vendorContact: vendorContact,
                                  bookingId: bookingId)
                              .then((value) => {
                                    if (value == false)
                                      {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderDelivered(
                                                        bookingId: bookingId)))
                                      }
                                    else
                                      {setState(() => visible = value)}
                                  });
                          // Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(theme_color)),
                        child: const Text("Submit"),
                      ),
                      const SizedBox(height: 10),
                    ],
                  )),
            ),
          );
        });
  }

  Future otpVerify(
      {required String vendorContact, required String bookingId}) async {
    final response = await http.post(
      Uri.parse("${Constants.BASE_URL}close-booking"),
      body: {
        "booking_id": bookingId,
        "vendor_contact": vendorContact,
        "otp": otp,
      },
    );

    var data = json.decode(response.body);
    var status = data["status"];

    if (status == true) {
      return false;
    } else {
      return true;
    }
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
        ),
      ),
      title: const TextWidget(
        text: 'MR DEAL Transactions',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  // Widget _totalPnts() {
  //   return Container(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         const SizedBox(
  //           height: 30,
  //         ),
  //         const TextWidget(
  //           text: 'Total points',
  //           size: text_size_18,
  //           weight: FontWeight.w500,
  //           alignment: TextAlign.center,
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             Icon(
  //               Icons.account_balance_wallet_outlined,
  //               color: blue_color,
  //               size: 30,
  //             ),
  //             SizedBox(
  //               width: 5,
  //             ),
  //             TextWidget(
  //               text: '0',
  //               size: text_size_30,
  //               weight: FontWeight.w600,
  //               alignment: TextAlign.center,
  //               color: blue_color,
  //             ),
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         const TextWidget(
  //           text: 'Mr. Deal Points',
  //           size: text_size_16,
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _walletAPiCall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _walletAPiCall() {
    var contact = {"contact": MrDealGlobals.userContact};
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        WalletPresenter().getTrxnDetails(this, contact, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isLoading = true;
          });
          WalletPresenter().getTrxnDetails(this, contact, context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60), child: _appbar()),
            body: _body(),
          )),
    );
  }

  @override
  void walletErr(error) {
    print('Contct verify == $error');
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: 'Something went wrong!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: red_color.shade700,
        fontSize: 16.0);
  }

  @override
  void walletResp(WalletModel walletModel) {
    _walletModelResp = walletModel;
    if (_walletModelResp?.status == true) {
    } else {
      Fluttertoast.showToast(
          msg: walletModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: red_color.shade700,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
