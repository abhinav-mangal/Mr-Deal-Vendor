import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';

import 'register_view.dart';

class RegisterPresenter {
  RegisterVendorView? _registerVendorView;

  void getLoginDetails(RegisterVendorView registerVendorView, _body) {
    _registerVendorView = registerVendorView;

    Apiconfig()
        .registerApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _registerVendorView?.registerResponse(value);
    }).catchError((err) {
      _registerVendorView?.registerErr(err);
    });
  }
}
