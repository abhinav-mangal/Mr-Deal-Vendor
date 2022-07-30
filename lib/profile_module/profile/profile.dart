import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_model.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_presenter.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_view.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VenderProfile extends StatefulWidget {
  const VenderProfile({Key? key}) : super(key: key);

  @override
  State<VenderProfile> createState() => _VenderProfileState();
}

class _VenderProfileState extends State<VenderProfile> implements ProfileView {
  bool _isLoading = true;
  var noConnection;
  VendorsModel? _profilDetails;

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 100,
        color: white_color,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              _image(),
              _ownerDetails(),
              const SizedBox(
                height: 30,
              ),
              _contctBtn()
            ],
          ),
        ),
      ),
    );
  }

  Widget _contctBtn() {
    return InkWell(
      onTap: () {
        phonecall(MrDealGlobals.userContact);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 70),
        width: 250,
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            color: const Color(0xff0e2c94),
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: const [
            Icon(
              Icons.phone_outlined,
              color: white_color,
            ),
            SizedBox(
              width: 25,
            ),
            TextWidget(
              text: 'Contact Us',
              color: white_color,
              weight: FontWeight.bold,
              size: text_size_16,
            )
          ],
        ),
        // child: GradientButtonWidget(
        //     onTap: () {
        //       phonecall(MrDealGlobals.userContact);
        //     },
        //     color: theme_color,
        //     child: const TextWidget(
        //       text: 'Contact Us',
        //       color: Colors.white,
        //       weight: FontWeight.bold,
        //       size: text_size_16,
        //     )),
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 150,
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
          text: 'Shop Details',
          size: text_size_18,
          color: white_color,
        ));
  }

  Widget _ownerDetails() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          TextWidget(
            text: _profilDetails?.data?.shopName ?? '',
            size: text_size_22,
            weight: FontWeight.bold,
          ),
          const SizedBox(
            height: 25,
          ),
          const TextWidget(
            text: 'Owner Name',
            size: text_size_20,
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
            size: text_size_20,
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
            size: text_size_20,
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

  phonecall(contactno) async {
    var contact = contactno;
    if (Platform.isAndroid) {
      launchUrlString("tel:$contact");
    } else {
      launchUrlString("tel://${contact.toString().replaceAll(" ", "%20")}");
    }
  }

  @override
  void initState() {
    super.initState();
    _profileAPiCall();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60), child: _appbar()),
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
  void profileResp(VendorsModel vendorsModel) {
    print('vendors profile resp --> ${vendorsModel.toMap()}');
    _profilDetails = vendorsModel;
    if (vendorsModel.status == true) {
      MrDealGlobals.userContact = vendorsModel.data?.contact ?? '';
      setState(() {
        _isLoading = false;
      });
      print(vendorsModel.data?.shopImage);
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: vendorsModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: shadow_color,
          textColor: black_color,
          fontSize: 16.0);
    }
  }
}
