import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_view.dart';

class ProfilePresenter {
  ProfileView? _profileView;

  void getProfileDetails(ProfileView profileView, _body, context) {
    _profileView = profileView;

    Apiconfig().profileAPi(http.Client(), _body, context).then((value) {
      _profileView?.profileResp(value);
    }).catchError((err) {
      _profileView?.profileErr(err);
    });
  }
}
