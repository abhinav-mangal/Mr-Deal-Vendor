import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';
import 'otp_view.dart';

class OtpVerifyPresenter {
  OtpVerifyView? _otpVerifyView;

  void getLoginDetails(OtpVerifyView otpVerifyView, _body, code) {
    _otpVerifyView = otpVerifyView;

    Apiconfig().verifyOtpApi(http.Client(), _body, code).then((value) {
      _otpVerifyView?.otpverfyResponse(value);
    }).catchError((err) {
      _otpVerifyView?.otpVerifyErr(err);
    });
  }
}
