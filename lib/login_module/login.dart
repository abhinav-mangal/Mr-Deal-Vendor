import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_app/Utls/deal_constant.dart';
import 'package:mr_deal_app/common_widgets/auth_utls.dart';
import 'package:mr_deal_app/common_widgets/button_widget.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/login_module/login_model.dart';

import '../terms_condition.dart';
import 'login_presenter.dart';
import 'login_view.dart';
import 'otp_module/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginVerifyView {
  var _phoneController = TextEditingController();
  bool _validPhone = false;
  bool _isLoading = false;
  var noConnection;
  bool _termsErr = false;
  bool _terms = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _phnField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: const TextWidget(
            text: 'Please enter your phone number',
            color: white_color,
            size: text_size_14,
            weight: FontWeight.normal,
            alignment: TextAlign.center,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 45,
          decoration: BoxDecoration(
              color: white_color,
              border: Border.all(width: 0.5, color: shadow_color),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 8,
              ),
              Container(
                // height: 35,
                color: transparent,
                width: MediaQuery.of(context).size.width - 180,
                child: TextFormField(
                    controller: _phoneController,
                    autofocus: false,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (_validPhone == true) {
                        setState(() {
                          _validPhone = false;
                        });
                      }
                    },
                    cursorColor: black_color,
                    cursorWidth: 1.0,
                    style: const TextStyle(
                        color: black_color,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                        prefixText: '+91 ',
                        prefixStyle: TextStyle(color: black_color),
                        counterText: '',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        hintText: "Enter Phone Number",
                        hintStyle: TextStyle(
                            color: GREY_COLOR_GREY_400,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none)),
              ),
            ],
          ),
        ),
        _validPhone
            ? Container(
                alignment: Alignment.centerLeft,
                color: transparent,
                margin: const EdgeInsets.only(left: 30, top: 8),
                child: TextWidget(
                    text: 'Please enter phone number',
                    size: text_size_13,
                    color: Colors.red.shade800),
              )
            : const SizedBox(
                height: 0,
              )
      ],
    );
  }

  Widget _termsnCondition() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            child: Checkbox(
              // activeColor: theme_color,

              checkColor: white_color,
              value: _terms,
              onChanged: (bool? value) {
                setState(() {
                  _terms = !_terms;
                  _termsErr = false;
                });
              },
            ),
          ),
          const TextWidget(
            text: 'I agree to the ',
            color: white_color,
            size: text_size_15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const TermsAndCondition(
                            checkURL: Constants.TERMS_CONDITION,
                          )));
            },
            child: const TextWidget(
              text: 'Terms & Conditions',
              color: theme_color,
              size: text_size_15,
              decoration: TextDecoration.underline,
            ),
          )
        ],
      ),
    );
  }

  _checkPhn(text) {
    var _regg = RegExp(r"^[0-9]");
    if (_regg.hasMatch(text) && _phoneController.text.length == 10) {
      setState(() {
        _validPhone = false;
      });
    } else {
      setState(() {
        _validPhone = true;
      });
    }
  }

  Widget _loginbtn() {
    return SizedBox(
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (contex) => const OTPPage()));

            if (_terms == false) {
              setState(() {
                _termsErr = true;
              });
            } else {
              _termsErr = false;
              if (_phoneController.text.isNotEmpty) {
                _checkPhn(_phoneController.text);
              } else {
                setState(() {
                  _validPhone = true;
                });
              }

              if (_validPhone == false) {
                var _requestBody = {
                  "contact": '${_phoneController.text}',
                };
                setState(() {
                  _isLoading = true;
                });
                Internetconnectivity().isConnected().then((value) async {
                  if (value == true) {
                    LoginVerifyPresenter().getLoginDetails(this, _requestBody);
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
                      LoginVerifyPresenter()
                          .getLoginDetails(this, _requestBody);
                    }
                  }
                });
              }
            }
          },
          color: _terms && _phoneController.text.length == 10
              ? theme_color
              : shadow_color,
          child: const TextWidget(
            text: 'Continue',
            color: Colors.white,
            weight: FontWeight.w500,
            size: 18,
          )),
    );
  }

  Widget _logo() {
    return SizedBox(height: 200, child: Image.asset('images/phone_img.png'));
  }

  Widget _body() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            height: 570,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(gradient: theme_gradient_color),
          ),
        ),
        Container(
          height: 580,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const TextWidget(
                text: 'Login',
                color: white_color,
                size: text_size_22,
                weight: FontWeight.w500,
                alignment: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              _logo(),
              const SizedBox(
                height: 10,
              ),
              _phnField(),
              const SizedBox(
                height: 10,
              ),
              _termsnCondition(),
              Container(
                alignment: Alignment.centerLeft,
                color: transparent,
                margin: const EdgeInsets.only(left: 30, top: 0),
                child: TextWidget(
                    text: _termsErr ? 'Please accept terms & Conditions' : '',
                    size: text_size_14,
                    color: Colors.red.shade800),
              ),
              const SizedBox(
                height: 45,
              ),
              _isLoading
                  ? Container(
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                          color: shadow_color,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Loader())
                  : _loginbtn()
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
            body: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SingleChildScrollView(
                  child: GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: _body())),
            ),
          )),
    );
  }

  @override
  void cntVerifyErr(error) {
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
  void cntcverfyResponse(ContactVerifyModel _contactVerifyModelResp) {
    print('conact resp ==>${_contactVerifyModelResp.toMap()}');
    setState(() {
      _isLoading = false;
    });
    if (_contactVerifyModelResp.status == true) {
      AuthUtils.setStringValue('user_contact', _phoneController.text);
      //  AuthUtils.setStringValue('user_id',_loginModel?. );
      setState(() {
        MrDealGlobals.userContact = _phoneController.text;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPPage(
                    contact: _phoneController.text,
                  )));
    } else {
      Fluttertoast.showToast(
          msg: _contactVerifyModelResp.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: red_color.shade700,
          fontSize: 16.0);
    }
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var firstStart = Offset(size.width / 2, size.height);
    var firstEnd = Offset(size.width / 2, size.height - 0);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width / 2, size.height);
    var secondEnd = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
