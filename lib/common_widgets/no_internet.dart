import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'colors_widget.dart';
import 'connectivity.dart';
import 'text_widget.dart';

class NoInternet extends StatefulWidget {
  final int? tabIndex;
  final String? noConnection;
  final String? type;

  const NoInternet({Key? key, this.noConnection, this.type, this.tabIndex})
      : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: white_color,
          resizeToAvoidBottomInset: false,
          body: _body(),
        ));
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: transparent,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            color: transparent,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'images/no_internet.png',
            ),
          ),
          const TextWidget(
            text: "No internet found",
            weight: FontWeight.w800,
            size: 22,
          ),
          const SizedBox(
            height: 60,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: theme_color.withOpacity(0.3),
                  offset: const Offset(1.0, 3.0),
                  blurRadius: 5.0,
                  spreadRadius: 3.0)
            ], color: theme_color, borderRadius: BorderRadius.circular(30)),
            height: 60,
            child: MaterialButton(
              child: const Text(
                "Try Again",
                style: TextStyle(
                    color: white_color,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              onPressed: () async {
                Internetconnectivity().isConnected().then((result) {
                  if (result) {
                    Navigator.pop(context, "1");
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget retrydata() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 20),
  //     child: Stack(
  //       alignment: Alignment.center,
  //       children: <Widget>[
  //         Container(
  //             height: MediaQuery.of(context).size.height,
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //                 color: red_color,
  //                 image: DecorationImage(
  //                   image: AssetImage(
  //                     "images/hotel/no_internet.png",
  //                   ),
  //                   fit: BoxFit.contain,
  //                 ))),
  //         Positioned(
  //           top: MediaQuery.of(context).size.height / 2.2,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               TextWidget(
  //                 text: "No internet found",
  //                 weight: FontWeight.w800,
  //                 size: 22,
  //               ),
  //               SizedBox(
  //                 height: 70,
  //               ),
  //               Container(
  //                 width: MediaQuery.of(context).size.width / 1.4,
  //                 decoration: BoxDecoration(
  //                     gradient: gradient_theme_color,
  //                     boxShadow: [
  //                       new BoxShadow(
  //                           color: orange_color.withOpacity(0.3),
  //                           offset: new Offset(1.0, 3.0),
  //                           blurRadius: 5.0,
  //                           spreadRadius: 3.0)
  //                     ],
  //                     borderRadius: BorderRadius.circular(30)),
  //                 height: 60,
  //                 child: MaterialButton(
  //                   child: Text(
  //                     "Try Again",
  //                     style: TextStyle(
  //                         color: white_text_color,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w700),
  //                   ),
  //                   onPressed: () async {
  //                     Internetconnectivity().isConnected().then((result) {
  //                       if (result) {
  //                         Navigator.pop(context, "1");
  //                       }
  //                     });
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
