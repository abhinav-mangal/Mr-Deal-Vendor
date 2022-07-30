import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_app/common_widgets/button_widget.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/profile_module/delete_acc/delete_acc_model.dart';
import 'package:mr_deal_app/profile_module/delete_acc/delete_acc_presenter.dart';
import 'package:mr_deal_app/profile_module/delete_acc/delete_acc_view.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_model.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_presenter.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editing_profile_module/edit_profilepage.dart';

class ProfileDisplay extends StatefulWidget {
  const ProfileDisplay({Key? key}) : super(key: key);

  @override
  State<ProfileDisplay> createState() => _ProfileDisplayState();
}

class _ProfileDisplayState extends State<ProfileDisplay>
    implements ProfileView, DeleteUserView {
  bool _isLoading = true;
  var noConnection;
  VendorsModel? _profilDetails;

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height + 70,
        color: white_color,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _image(),
            _ownerDetails(),
            const SizedBox(
              height: 20,
            ),
            _deleteAccBtn(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
          color: shadow_color, borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: _profilDetails?.data?.shopImage ?? '',
          fit: BoxFit.fill,
          placeholder: (context, url) => const Loader(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _ownerDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: TextWidget(
                  text: _profilDetails?.data?.shopName ?? 'Shop Name',
                  size: text_size_20,
                  weight: FontWeight.w600,
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       shape: BoxShape.circle, color: Colors.grey.shade200),
              //   child: IconButton(
              //       onPressed: () {
              //         print('edit');
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (contex) => EditProfilePage(
              //                       profilDetails: _profilDetails,
              //                     )));
              //       },
              //       icon: const Icon(Icons.edit)),
              // )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const TextWidget(
            text: 'Owner Name',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _profilDetails?.data?.ownerName ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 15,
          ),
          const TextWidget(
            text: 'Contact Number',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _profilDetails?.data?.contact ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 15,
          ),
          const TextWidget(
            text: 'Address',
            size: text_size_18,
            color: black_color,
            weight: FontWeight.w600,
          ),
          const SizedBox(
            height: 5,
          ),
          TextWidget(
            text: _profilDetails?.data?.address ?? '',
            size: text_size_16,
            color: GREY_COLOR_GREY,
            weight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
        ),
      ),
      title: const TextWidget(
        text: 'Profile',
        size: text_size_18,
        color: white_color,
      ),
      actions: [
        Row(
          children: [
            TextWidget(
              text: 'Logout',
              size: text_size_15,
              color: white_color,
            ),
            IconButton(
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Logout',
              onPressed: () {
                _onexit();

                // handle the press
              },
            ),
          ],
        ),
      ],
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
                  weight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'want to Logout?',
                    size: 18,
                    weight: FontWeight.w500,
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
                              weight: FontWeight.w500),
                        ),
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
                              weight: FontWeight.w500),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileAPiCall();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _profileAPiCall() {
    var contact = MrDealGlobals.userContact;
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        ProfilePresenter().getProfileDetails(this, contact, context);
      } else {
        setState(() {
          _isLoading = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isLoading = true;
          });
          ProfilePresenter().getProfileDetails(this, contact, context);
        }
      }
    });
  }

  Widget _deleteAccBtn() {
    return SizedBox(
      width: 150,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            _ondeleteAcc();
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Delete Account',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_16,
          )),
    );
  }

  void _deleteAccApiCall() {
    Internetconnectivity().isConnected().then((value) async {
      if (value == true) {
        DeleteAccPresenter().getLoginDetails(this);
      } else {
        setState(() {
          _isLoading = false;
        });
        noConnection = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isLoading = true;
          });
          DeleteAccPresenter().getLoginDetails(this);
        }
      }
    });
  }

  Future<bool> _ondeleteAcc() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 150,
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: 'Are you sure you want to',
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'Delete your Account',
                    size: 16,
                    weight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(
                  child: TextWidget(
                    text: 'permanently?',
                    size: 16,
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
                              size: 14,
                              color: Colors.white,
                              weight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _isLoading = true;
                          });
                          _deleteAccApiCall();
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
                              size: 14,
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
      child: Scaffold(
        appBar: PreferredSize(
            child: _appbar(), preferredSize: const Size.fromHeight(60)),
        body: _isLoading
            ? Center(
                child: Container(
                    child: Image.asset(
                  'images/gears.gif',
                  height: 60,
                )),
              )
            : _body(),
      ),
    );
  }

  @override
  void profileErr(error) {
    print('error--> $error');
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }

  @override
  void profileResp(VendorsModel _vendorsModel) {
    print('vendors profile resp --> ${_vendorsModel.toMap()}');
    if (_vendorsModel.status == true) {
      setState(() {
        _profilDetails = _vendorsModel;
        MrDealGlobals.lat = double.parse(_profilDetails?.data?.lat ?? '0.0');
        MrDealGlobals.long = double.parse(_profilDetails?.data?.long ?? '0.0');
        _isLoading = false;
      });
      print(_vendorsModel.data?.shopImage);
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: _vendorsModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
    }
  }

  @override
  void deleteAccErr(error) {
    setState(() {
      _isLoading = false;
    });
    print('DELETE ACC -->  $error');
    Fluttertoast.showToast(
        msg: error ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }

  @override
  Future<void> deleteAccResp(DeleteUserModel _deleteUserModel) async {
    print('delete Acc resp -- ${_deleteUserModel.toMap()}');
    if (_deleteUserModel.status == true) {
      Fluttertoast.showToast(
          msg: 'Your account is deleted successfully.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
      MrDealGlobals.userContact = '';
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear();
      _isLoading = false;
      setState(() {});
      Navigator.pushNamedAndRemoveUntil(context, "/LoginPage", (r) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: _deleteUserModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
    }
  }
}
