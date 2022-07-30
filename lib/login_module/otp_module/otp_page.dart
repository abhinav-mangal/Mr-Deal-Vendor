import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_app/common_widgets/auth_utls.dart';
import 'package:mr_deal_app/common_widgets/button_widget.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/home_module/home_pg.dart';
import 'package:mr_deal_app/login_module/login_model.dart';
import 'package:mr_deal_app/login_module/otp_module/otp_model.dart';
import 'package:mr_deal_app/login_module/register_module/register_vendor.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../login.dart';
import '../login_presenter.dart';
import '../login_view.dart';
import 'otp_presenter.dart';
import 'otp_view.dart';

class OTPPage extends StatefulWidget {
  final String? contact;
  const OTPPage({Key? key, required this.contact}) : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage>
    implements OtpVerifyView, LoginVerifyView {
  final _pincontroller = TextEditingController();
  bool _isLoading = false;
  var noConnection;
  bool _resendLoader = false;
  bool _otpErr = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _logo() {
    return SizedBox(height: 150, child: Image.asset('images/phone_img.png'));
  }

  Widget _loginbtn() {
    return SizedBox(
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            if (_pincontroller.text.isNotEmpty) {
              var _reqBody = {"contact": "${widget.contact}"};
              setState(() {
                _isLoading = true;
                _otpErr = false;
              });

              Internetconnectivity().isConnected().then((value) async {
                if (value == true) {
                  OtpVerifyPresenter()
                      .getLoginDetails(this, _reqBody, _pincontroller.text);
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  noConnection = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const NoInternet()));
                  if (noConnection != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    OtpVerifyPresenter()
                        .getLoginDetails(this, _reqBody, _pincontroller.text);
                  }
                }
              });
            } else {
              setState(() {
                _otpErr = true;
              });
            }
          },
          color: theme_color,
          child: const TextWidget(
            text: 'SUBMIT',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_16,
          )),
    );
  }

  Widget _otp() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 55,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40.0),
                border: Border.all(width: 0, color: transparent)),
            child: Center(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 100,
                // margin: const EdgeInsets.only(left: 50, right: 50),
                child: PinCodeTextField(
                  appContext: context,
                  enablePinAutofill: false,
                  mainAxisAlignment: MainAxisAlignment.center,
                  pastedTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,
                  obscureText: true,
                  obscuringCharacter: '*',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeFillColor: Colors.white,
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      borderWidth: 2,
                      selectedColor: Colors.grey,
                      shape: PinCodeFieldShape.underline,
                      fieldOuterPadding: const EdgeInsets.only(
                          top: 6, left: 6, right: 6, bottom: 8),
                      fieldHeight: 35,
                      fieldWidth: 35),
                  cursorColor: Colors.black,
                  controller: _pincontroller,
                  cursorHeight: 19,
                  cursorWidth: 1.2,
                  backgroundColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  autoFocus: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onCompleted: (value) {},
                  onChanged: (value) {
                    setState(() {
                      _otpErr = false;
                    });
                  },
                ),
              ),
            ),
          ),
          // _isvalid
          //     ? Container(
          //         height: 15,
          //         margin: EdgeInsets.only(top: 0, bottom: 10),
          //         alignment: Alignment.center,
          //         child: TextWidget(
          //             text: errormsg,
          //             color: red_color,
          //             size: text_font_size_x_small,
          //             weight: FontWeight.w700),
          //       )
          //     : Container(
          //         height: 15,
          // ),
        ],
      ),
    );
  }

  Widget _lowerBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: white_color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadow_color,
            offset: Offset(2.0, 2.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'OTP',
            color: black_color,
            weight: FontWeight.w600,
            size: text_size_20,
          ),
          const SizedBox(
            height: 40,
          ),
          const TextWidget(
            text: 'Enter your digital OTP here',
            color: black_color,
            weight: FontWeight.normal,
            size: text_size_15,
          ),
          const SizedBox(
            height: 20,
          ),
          _otp(),
          _otpErr
              ? Container(
                  alignment: Alignment.center,
                  color: transparent,
                  margin: const EdgeInsets.only(left: 0, top: 0),
                  child: TextWidget(
                      text: 'Please enter valid OTP.',
                      size: text_size_14,
                      color: Colors.red.shade800),
                )
              : SizedBox(
                  height: 0,
                ),
          const SizedBox(
            height: 40,
          ),
          _isLoading
              ? Container(
                  height: 50,
                  width: 120,
                  child: const Loader(),
                )
              : _loginbtn(),
          const SizedBox(
            height: 30,
          ),
          const TextWidget(
            text: "Did n't receive OTP? ",
            color: black_color,
            weight: FontWeight.normal,
            size: text_size_15,
          ),
          const SizedBox(
            height: 10,
          ),
          _resendLoader
              ? Container(
                  height: 45,
                  width: 100,
                  child: const Loader(),
                )
              : GestureDetector(
                  onTap: () {
                    var _requestBody = {
                      "contact": '${widget.contact}',
                    };
                    setState(() {
                      _resendLoader = true;
                    });
                    Internetconnectivity().isConnected().then((value) async {
                      if (value == true) {
                        LoginVerifyPresenter()
                            .getLoginDetails(this, _requestBody);
                      } else {
                        setState(() {
                          _resendLoader = false;
                        });
                        noConnection = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const NoInternet()));
                        if (noConnection != null) {
                          setState(() {
                            _resendLoader = true;
                          });
                          LoginVerifyPresenter()
                              .getLoginDetails(this, _requestBody);
                        }
                      }
                    });
                  },
                  child: const TextWidget(
                    text: "Click here",
                    color: Colors.blue,
                    weight: FontWeight.normal,
                    size: text_size_16,
                  ),
                ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(gradient: theme_gradient_color)),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: transparent,
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              _logo(),
              const SizedBox(
                height: 20,
              ),
              _lowerBody()
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparent,
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: WillPopScope(onWillPop: _onWillPop, child: _body())),
          )),
    );
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  void otpVerifyErr(error) {
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
  void otpverfyResponse(OtpVerifyModel _otpVerifyModel) {
    if (_otpVerifyModel.status == true &&
        _otpVerifyModel.data?.isRegistered == true) {
      setState(() {
        _isLoading = false;
        AuthUtils.setStringValue('contact', widget.contact);
        MrDealGlobals.userContact = widget.contact ?? '';
      });
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const TabbarPage(
                    initialIndex: 0,
                  )));
    } else if (_otpVerifyModel.status == true &&
        _otpVerifyModel.data?.isRegistered == false) {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => RegisterVendorPage(
                    contct: widget.contact,
                  )));
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    Fluttertoast.showToast(
        msg: _otpVerifyModel.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }

  @override
  void cntVerifyErr(error) {
    setState(() {
      _resendLoader = false;
    });
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }

  @override
  void cntcverfyResponse(ContactVerifyModel _contactVerifyModelResp) {
    setState(() {
      _resendLoader = false;
    });
    Fluttertoast.showToast(
        msg: _contactVerifyModelResp.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }
}
