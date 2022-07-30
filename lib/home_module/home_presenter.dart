import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';

import 'home_view.dart';

class HomePgPresenter {
  HomepageView? _homepageView;

  void getHomepageResp(HomepageView homepageView, _context) {
    _homepageView = homepageView;

    Apiconfig().homepageApi(http.Client(), _context).then((value) {
      _homepageView?.homepageResponse(value);
    }).catchError((err) {
      _homepageView?.homepgErr(err);
    });
  }
}
