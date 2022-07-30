import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_deal_app/common_widgets/button_widget.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/home_module/home_pg.dart';
import 'package:mr_deal_app/login_module/register_module/address_map.dart';
import 'package:mr_deal_app/profile_module/edit_profile/editing_profile_module/edit_model.dart';
import 'package:mr_deal_app/profile_module/profile/vendor_model.dart';
import 'package:path_provider/path_provider.dart';

import 'edit_presenter.dart';
import 'edit_view.dart';

class EditProfilePage extends StatefulWidget {
  final VendorsModel? profilDetails;
  const EditProfilePage({Key? key, required this.profilDetails})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    implements EditProfileView {
  final _shopNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _Controller = TextEditingController();
  VendorsModel? _profilDetails;
  var noConnection;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  var _imagePathbase64;
  double? _lat;
  double? _long;
  String? _address;

  void _editprofileAPICall() {
    Internetconnectivity().isConnected().then((value) async {
      var request;
      if (_imagePathbase64 != null) {
        setState(() {
          request = {
            "contact": _contactController.text,
            "address": _addressController.text,
            "is_registered": true,
            "lat": MrDealGlobals.lat.toString(),
            "long": MrDealGlobals.long.toString(),
            "owner_name": _ownerNameController.text,
            "points": 0,
            "shop_image": _imagePathbase64 ?? '',
            "shop_name": _shopNameController.text
          };
        });
      } else {
        setState(() {
          request = {
            "contact": _contactController.text,
            "address": _addressController.text,
            "is_registered": true,
            "lat": MrDealGlobals.lat.toString(),
            "long": MrDealGlobals.long.toString(),
            "owner_name": _ownerNameController.text,
            "points": 0,
            // "shop_image": _imagePathbase64 ?? _profilDetails?.data?.shopImage ?? '',
            "shop_name": _shopNameController.text
          };
        });
      }

      if (value == true) {
        EditProfilePresenter().getLoginDetails(this, request, context);
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
          EditProfilePresenter().getLoginDetails(this, request, context);
        }
      }
    });
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
        text: 'Profile Edit',
        size: text_size_18,
        color: white_color,
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.maybePop(context);
          }),
    );
  }

  Widget _shopNameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.house_outlined,
            size: 30,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _shopNameController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter Shop name",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownerNameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.person_outline,
            size: 30,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _ownerNameController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter owner name",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: const Icon(
              Icons.location_on_outlined,
              size: 30,
            ),
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _addressController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 200,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  maxLines: 6,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                      hintText: "Enter your shop address",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.phone_outlined,
            size: 30,
            color: GREY_COLOR_GREY,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _contactController,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  cursorColor: GREY_COLOR_GREY,
                  enabled: false,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: GREY_COLOR_GREY,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {},
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter contact number",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pinCodeField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          const Icon(
            Icons.location_searching,
            size: 30,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _ownerNameController,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  maxLength: 6,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {},
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter contact number",
                      hintStyle: TextStyle(
                          color: GREY_COLOR_GREY_400,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      border: InputBorder.none)),
            ),
          ),
        ],
      ),
    );
  }

  CompressFormat _getcompressformat(String extensionName) {
    switch (extensionName.toLowerCase()) {
      case "png":
        return CompressFormat.png;

      case "heic":
        return CompressFormat.heic;
      case "webp":
        return CompressFormat.webp;

      case "jpg":
      case "jpeg":
        return CompressFormat.jpeg;
      default:
        return CompressFormat.png;
    }
  }

  Future<void> _takephoto(ImageSource source) async {
    final _pickedFile = await _picker.pickImage(
      source: source,
    );

    if (_pickedFile != null) {
      final _extension = _pickedFile.path.split(".").last;

      final _format = _getcompressformat(_extension);
      if (_format != null) {
        final tempDir =
            '${(await getTemporaryDirectory()).absolute.path}/${DateTime.now().millisecondsSinceEpoch}.$_extension';
        final _compressedFile = await FlutterImageCompress.compressAndGetFile(
            _pickedFile.path, tempDir,
            format: _getcompressformat(_extension), quality: 88);

        setState(() {
          _imagePathbase64 = "data:image/png;base64," +
              base64Encode(File(_compressedFile!.path).readAsBytesSync());
          // = "data:image/png;base64," +
          //     base64Encode(_compressedFile!.readAsBytesSync());
          _imagePath = _compressedFile.path;

          MrDealGlobals.localImg = _imagePath;
          print('_imagePath=============== $_imagePath');
        });
      }
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const TextWidget(
            text: "Choose Photo",
            color: Colors.black,
            weight: FontWeight.bold,
            size: 20,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                  onPressed: () {
                    _takephoto(ImageSource.camera)
                        .whenComplete(() => Navigator.pop(context));
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              TextButton.icon(
                  onPressed: () {
                    _takephoto(ImageSource.gallery)
                        .whenComplete(() => Navigator.pop(context));
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  Widget _clickPic() {
    return SizedBox(
      width: 160,
      height: 40,
      child: GradientButtonWidget(
          onTap: () {
            showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));
          },
          color: Colors.grey.shade100,
          child: const TextWidget(
            text: 'Click Shop Image',
            color: black_color,
            weight: FontWeight.bold,
            size: text_size_14,
          )),
    );
  }

  Widget _submitBtn() {
    return SizedBox(
      width: 160,
      height: 40,
      child: GradientButtonWidget(
          onTap: () {
            setState(() {
              _isLoading = true;
            });
            _editprofileAPICall();
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Submit',
            color: white_color,
            weight: FontWeight.bold,
            size: text_size_14,
          )),
    );
  }

  Widget _addAddressBtn() {
    return SizedBox(
      width: 200,
      height: 50,
      child: GradientButtonWidget(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressMap()),
            ).then((value) {
              if (value != null) {
                setState(() {
                  _lat = value['lat'];
                  _long = value['long'];
                  _address = value['address'];
                  _addressController.text = value['address'];
                });
              }
            });
          },
          color: theme_color,
          child: const TextWidget(
            text: 'Add Shop Address',
            color: white_color,
            weight: FontWeight.w500,
            size: text_size_14,
          )),
    );
  }

  Widget _image() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
                color: shadow_color, borderRadius: BorderRadius.circular(5)),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: _imagePath != null
                  ? Image.file(
                      File(_imagePath!),
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: _profilDetails?.data?.shopImage ?? '',
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Loader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
            ),
          ),
          Center(child: _clickPic())
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white_color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _image(),
          SizedBox(
            height: 25,
          ),
          _shopNameField(),
          const SizedBox(
            height: 15,
          ),
          _ownerNameField(),
          const SizedBox(
            height: 15,
          ),
          _contactField(),
          const SizedBox(
            height: 15,
          ),
          _addAddressBtn(),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AddressMap()),
          //     ).then((value) {
          //       if (value != null) {
          //         setState(() {
          //           _lat = value['lat'];
          //           _long = value['long'];
          //           _address = value['address'];
          //           _addressController.text = value['address'];
          //         });
          //       }
          //     });
          //   },
          //   child: Container(
          //     alignment: Alignment.centerLeft,
          //     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //     child: const TextWidget(
          //       text: 'Add Shop Address (+)',
          //       size: text_size_16,
          //       weight: FontWeight.w500,
          //       color: blue_color,
          //     ),
          //   ),
          // ),

          _addressField(),
          const SizedBox(
            height: 15,
          ),
          // _pinCodeField(),
          const SizedBox(
            height: 45,
          ),
          _isLoading
              ? Container(
                  height: 50,
                  width: 120,
                  child: const Loader(),
                )
              : _submitBtn(),
          const SizedBox(
            height: 45,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profilDetails = widget.profilDetails;
    _ownerNameController.text = _profilDetails?.data?.ownerName ?? '';
    _shopNameController.text = _profilDetails?.data?.shopName ?? '';
    _contactController.text = _profilDetails?.data?.contact ?? '';
    _addressController.text = _profilDetails?.data?.address ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: PreferredSize(
                child: _appbar(), preferredSize: const Size.fromHeight(60)),
            body: SingleChildScrollView(child: _body()),
          )),
    );
  }

  @override
  void editProdileErr(error) {
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
  void editprofileResp(EditProfileModel _editProfileModel) {
    setState(() {
      _isLoading = false;
    });
    if (_editProfileModel.status == true) {
      if (_lat != null && _long != null) {
        setState(() {
          MrDealGlobals.lat = _lat ?? 0.0;
          MrDealGlobals.long = _long ?? 0.0;
        });
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (contex) => const TabbarPage(
                    initialIndex: 0,
                  )));
    }
    Fluttertoast.showToast(
        msg: _editProfileModel.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }
}
