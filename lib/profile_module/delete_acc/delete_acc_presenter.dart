import 'package:http/http.dart' as http;
import 'package:mr_deal_app/Utls/apiconfig.dart';

import 'delete_acc_view.dart';

class DeleteAccPresenter {
  DeleteUserView? _deleteUserView;

  void getLoginDetails(DeleteUserView deleteUserView) {
    _deleteUserView = deleteUserView;

    Apiconfig()
        .deleteAccApi(
      http.Client(),
    )
        .then((value) {
      _deleteUserView?.deleteAccResp(value);
    }).catchError((err) {
      _deleteUserView?.deleteAccErr(err);
    });
  }
}
