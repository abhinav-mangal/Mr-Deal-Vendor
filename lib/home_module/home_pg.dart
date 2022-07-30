/*Author:Animesh Banerjee
Description:homepage Tabbar Page for bottom navigation*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/home_module/user_device_module/user_homepage.dart';
import 'package:mr_deal_app/profile_module/edit_profile/edit_profile.dart';
import 'package:mr_deal_app/profile_module/profile/profile.dart';
import 'package:mr_deal_app/wallet_module/wallet.dart';
import 'package:mr_deal_app/wallet_module/wallet_model.dart';
import 'package:mr_deal_app/wallet_module/wallet_presenter.dart';
import 'package:mr_deal_app/wallet_module/wallet_view.dart';

import 'package:url_launcher/url_launcher.dart';

import '../generate_scanner.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({
    Key? key,
    required this.initialIndex,
  }) : super(key: key);

  final initialIndex;

  @override
  _TabbarPageState createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage>
    with SingleTickerProviderStateMixin
    implements WalletView {
  TabController? _tabController;
  int? _tabindex = 0;
  GlobalKey<ScaffoldState> _tabscaffoldKey = new GlobalKey<ScaffoldState>();
  var _tabval;
  var showappbar = true;
  WalletModel? _walletModelResp;
  int deniedTap = 0;
  int _unReadNoticount = 0;
  bool _showAppBar = true;
  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  GlobalKey keyButton4 = GlobalKey();
  GlobalKey keyButton5 = GlobalKey();
  GlobalKey keyButton6 = GlobalKey();
  var noConnection;

  @override
  void initState() {
    super.initState();
    print('@@@@@@@@@@@@@@@@@@');
    _walletAPiCall();
    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 4, vsync: this);
  }

  void _launchURL(_url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  void _walletAPiCall() {
    var contact = {"contact": MrDealGlobals.userContact};
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        WalletPresenter().getTrxnDetails(this, contact, context);
      } else {
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          WalletPresenter().getTrxnDetails(this, contact, context);
        }
      }
    });
  }

/*Bottom TabBar */
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 1, 0, 3),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              blurRadius: 12,
              color: Color.fromRGBO(0, 0, 0, 0.16),
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          // border: Border(
          //   top: BorderSide(color: shadow_color, width: 0.5),
          // ),
          color: white_color),
      height: 65,
      child: TabBar(
        isScrollable: false,
        controller: _tabController,
        indicatorColor: transparent,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: [
          Tab(
            key: keyButton2,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.home,
                  color: _tabindex == 0 ? theme_color : shadow_color,
                  size: 30,
                ),
              ),
            ),
          ),
          Tab(
            key: keyButton3,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.qr_code_scanner,
                  color: _tabindex == 1 ? theme_color : shadow_color,
                  size: 30,
                ),
              ),
            ),
          ),
          Tab(
            key: keyButton4,
            child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                height: 40,
                // child: Image.asset(
                //   'images/trxn.png',
                //   height: 30,
                // )
                child: Image.asset(
                  'images/trxn.png',
                  color: _tabindex == 2 ? theme_color : shadow_color,
                )

                //     Icon(
                //   Icons.account_balance_wallet_rounded,
                //   size: 30,
                //   color: _tabindex == 2 ? theme_color : shadow_color,
                // ),
                ),
          ),
          Tab(
            key: keyButton5,
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Icon(
                  Icons.person,
                  color: _tabindex == 3 ? theme_color : shadow_color,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
        onTap: (tabIndex) {
          switch (tabIndex) {
            case 0:
              setState(() {
                _tabindex = 0;
              });

              break;
            case 1:
              setState(() {
                _tabindex = 1;
              });

              break;
            case 2:
              setState(() {
                _tabindex = 2;
              });

              break;
            case 3:
              setState(() {
                _tabindex = 3;
              });

              break;

            default:
              _tabindex = 2;
              _tabval = "Home";
          }
        },
      ),
    );
  }

  Widget _body() {
    return TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          const UserHomePage(),
          GenerateQR(
            walletModelResp: _walletModelResp,
          ),
          const WalletPage(),
          const ProfileDisplay()
        ]);
  }

/*BottomSheet for inStore */
  Widget bottomSheet() {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: white_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 4, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextWidget(
                  text: 'Are you sure you want to exit ',
                  size: 17,
                ),
                TextWidget(
                  text: ' ?',
                  size: 17,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: shadow_color, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  TextWidget(
                    text: 'Yes',
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade300, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop(false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  TextWidget(
                    text: 'No',
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?>? _onWillPop() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 120,
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: "Are you sure you",
                  size: 10,
                  weight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: "want to exit?",
                  size: 10,
                  weight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: theme_color.withOpacity(0.5),
                                  offset: const Offset(0.0, 5.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0)
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const TextWidget(
                              text: "No",
                              size: 12,
                              color: white_color,
                              weight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Container(
                          width: 80,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: theme_color.withOpacity(0.5),
                                  offset: const Offset(0.0, 5.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 0.0)
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const TextWidget(
                              text: "Yes",
                              size: 12,
                              color: white_color,
                              weight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onexit() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 140,
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: 'Are you sure you',
                  size: 18,
                  weight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'want to exit?',
                    size: 18,
                    weight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
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
                              text: 'No',
                              size: 15,
                              color: Colors.white,
                              weight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
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
                              text: 'Yes',
                              size: 15,
                              color: Colors.white,
                              weight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff0e2c94),
      ),
      child: SafeArea(
          top: true,
          bottom: true,
          child: Scaffold(
            key: _tabscaffoldKey,
            extendBody: true,
            bottomNavigationBar: _bottomBar(),
            body: WillPopScope(onWillPop: _onexit, child: _body()),
          )),
    );
  }

  @override
  void walletErr(error) {
    // TODO: implement walletErr
  }

  @override
  void walletResp(WalletModel _walletModel) {
    setState(() {
      _walletModelResp = _walletModel;
      MrDealGlobals.vendorPnts =
          _walletModelResp?.data?[0].shopDetails?.points ?? 0;
    });
  }
}
