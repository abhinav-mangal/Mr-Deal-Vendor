import 'package:flutter/material.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_widgets/button_widget.dart';
import 'common_widgets/globals.dart';
import 'common_widgets/text_widget.dart';
import 'login_module/login.dart';

class DeactivatedUser extends StatefulWidget {
  const DeactivatedUser({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  State<DeactivatedUser> createState() => _DeactivatedUserState();
}

class _DeactivatedUserState extends State<DeactivatedUser> {
  Widget _body() {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: GREY_COLOR_GREY_400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget(
              text:
                  'Your account has been deleted.Please contact administrator for futher queries.',
              size: 20,
              color: black_color,
              weight: FontWeight.bold,
              alignment: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                MrDealGlobals.userContact = '';
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.clear();
                setState(() {});
                Navigator.pushNamedAndRemoveUntil(
                    context, "/LoginPage", (r) => false);
              },
              child: Container(
                width: 150,
                height: 50,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 1.0,
                        spreadRadius: 0.0)
                  ],
                  color: theme_color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const TextWidget(
                    text: 'OK',
                    size: 15,
                    color: Colors.white,
                    weight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Scaffold(
        body: _body(),
      ),
    );
  }
}
