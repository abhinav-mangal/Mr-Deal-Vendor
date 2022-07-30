import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';

import 'login_view.dart';

class LoginVerifyPresenter {
  LoginVerifyView? _loginVerifyView;

  void getLoginDetails(LoginVerifyView loginVerifyView, _body) {
    _loginVerifyView = loginVerifyView;

    Apiconfig()
        .verifyContactApi(
      http.Client(),
      _body,
    )
        .then((value) {
      _loginVerifyView?.cntcverfyResponse(value);
    }).catchError((err) {
      _loginVerifyView?.cntVerifyErr(err);
    });
  }
}
