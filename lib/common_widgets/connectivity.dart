import 'package:connectivity/connectivity.dart';

class Internetconnectivity {
  Future<dynamic> isConnected() async {
    bool connection = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      connection = true;
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      connection = true;
    } else {
      //notconnected
      connection = false;
    }
    return connection;
  }
}
