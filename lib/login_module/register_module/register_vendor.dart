import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mr_deal_app/common_widgets/auth_utls.dart';
import 'package:mr_deal_app/common_widgets/button_widget.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/connectivity.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/no_internet.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';
import 'package:mr_deal_app/home_module/home_pg.dart';
import 'package:mr_deal_app/login_module/register_module/register_model.dart';
import 'package:mr_deal_app/login_module/register_module/register_view.dart';
import 'package:path_provider/path_provider.dart';

import '../login.dart';
import 'address_map.dart';
import 'register_presenter.dart';

class RegisterVendorPage extends StatefulWidget {
  final String? contct;
  const RegisterVendorPage({Key? key, required this.contct}) : super(key: key);

  @override
  State<RegisterVendorPage> createState() => _RegisterVendorPageState();
}

class _RegisterVendorPageState extends State<RegisterVendorPage>
    implements RegisterVendorView {
  final TextEditingController? _pincontroller = TextEditingController();
  final TextEditingController? _nameController = TextEditingController();
  final TextEditingController? _shopNameController = TextEditingController();
  final TextEditingController? _addressController = TextEditingController();
  bool _isLoading = false;
  var noConnection;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  var _imagePathbase64;
  String _nmValidatn = '';
  String _snValidatn = '';
  String _saddValidatn = '';
  String _simgValidation = '';
  double? _lat;
  double? _long;
  String? _address;

  @override
  void initState() {
    super.initState();
    _lat = MrDealGlobals.lat;
    _long = MrDealGlobals.long;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _logo() {
    return SizedBox(
        height: 120,
        child: Image.asset(
          'images/mobile-shop.png',
          fit: BoxFit.fill,
        ));
  }

  Widget _registerbtn() {
    return SizedBox(
      width: 200,
      height: 45,
      child: GradientButtonWidget(
          onTap: () {
            _ownerNm();
            _shopNm();
            _shopAddrss();
            _shopImg();
            if (!_ownerNm() && !_shopNm() && !_shopAddrss() && !_shopImg()) {
              setState(() {
                _isLoading = true;
              });
              var _reqBody = {
                "contact": widget.contct ?? '',
                "address": _addressController?.text ?? '',
                "is_registered": true,
                "lat": _lat.toString(),
                "long": _long.toString(),
                "owner_name": _nameController?.text ?? '',
                "points": 0,
                "shop_image": _imagePathbase64 ?? '',
                "shop_name": _shopNameController?.text ?? '',
              };

              Internetconnectivity().isConnected().then((value) async {
                if (value == true) {
                  RegisterPresenter().getLoginDetails(this, _reqBody);
                } else {
                  setState(() {
                    _isLoading = false;
                  });
                  noConnection = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const NoInternet()));
                  if (noConnection != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    RegisterPresenter().getLoginDetails(this, _reqBody);
                  }
                }
              });
            }
          },
          color: theme_color,
          child: const TextWidget(
            text: 'REGISTER',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_16,
          )),
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

  bool _ownerNm() {
    if (_nameController!.text.isNotEmpty) {
      _nmValidatn = '';
      setState(() {});
      return false;
    } else {
      _nmValidatn = 'Please enter your name';
      setState(() {});
      return true;
    }
  }

  bool _shopNm() {
    if (_shopNameController!.text.isNotEmpty) {
      _snValidatn = '';
      setState(() {});
      return false;
    } else {
      _snValidatn = 'Please enter your shop name';
      setState(() {});
      return true;
    }
  }

  bool _shopAddrss() {
    if (_addressController!.text.isNotEmpty) {
      _saddValidatn = '';
      setState(() {});
      return false;
    } else {
      _saddValidatn = 'Please enter your shop address';
      setState(() {});
      return true;
    }
  }

  bool _shopImg() {
    if (_imagePath != null) {
      _simgValidation = '';
      setState(() {});
      return false;
    } else {
      _simgValidation = 'Please select your shop image';
      setState(() {});
      return true;
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
          _shopImg();
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
            weight: FontWeight.w600,
            size: 20,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          color: theme_color,
          child: const TextWidget(
            text: 'Click Shop Image',
            color: Colors.white,
            weight: FontWeight.w600,
            size: text_size_14,
          )),
    );
  }

  Widget _nameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              color: transparent,
              width: MediaQuery.of(context).size.width - 180,
              child: TextFormField(
                  controller: _nameController,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  cursorColor: black_color,
                  cursorWidth: 1.0,
                  style: const TextStyle(
                      color: black_color,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  onChanged: (value) {
                    _ownerNm();
                  },
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

  Widget _shopnameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
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
                  onChanged: (value) {
                    _shopNm();
                  },
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                      hintText: "Enter your shop name",
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

  Widget _shopAddressField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // height: 45,
      decoration: BoxDecoration(
          color: white_color,
          border: Border.all(width: 0.5, color: shadow_color),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 8,
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
                  onChanged: (value) {
                    _shopAddrss();
                  },
                  decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                  _addressController?.text = value['address'];
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

  Widget _lowerBody() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white_color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadow_color,
            offset: Offset(2.0, 2.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const TextWidget(
            text: 'Shop Details',
            color: black_color,
            weight: FontWeight.w600,
            size: text_size_20,
          ),
          const SizedBox(
            height: 10,
          ),
          ClipOval(
              child: Container(
            height: 90,
            width: 90,
            color: Colors.transparent,
            child: _imagePath != null
                ? Image.file(
                    File(_imagePath!),
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.house_outlined,
                    size: 80,
                  ),
          )),
          const SizedBox(
            height: 10,
          ),
          _clickPic(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _simgValidation,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _nameField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _nmValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          _shopnameField(),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 5),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _snValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
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
          //           _addressController?.text = value['address'];
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
          _address != null
              ? _shopAddressField()
              : const SizedBox(
                  height: 0,
                ),
          Container(
            margin: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
            alignment: Alignment.centerLeft,
            child: TextWidget(
              text: _saddValidatn,
              color: red_color.shade700,
              size: text_size_14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _isLoading
              ? Container(
                  height: 50,
                  width: 120,
                  child: const Loader(),
                )
              : _registerbtn(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(gradient: theme_gradient_color)),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: transparent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                _logo(),
                const SizedBox(
                  height: 30,
                ),
                _lowerBody(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: transparent,
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            body: _body(),
          )),
    );
  }

  @override
  void registerErr(error) {
    print(error);
    setState(() {
      _isLoading = false;
    });
    Fluttertoast.showToast(
        msg: 'Something went wrong!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: red_color.shade700,
        fontSize: 16.0);
  }

  @override
  void registerResponse(RegisterModel _registerModel) {
    print(_registerModel.toMap());
    setState(() {
      _isLoading = false;
      AuthUtils.setStringValue('contact', widget.contct);
      MrDealGlobals.userContact = widget.contct ?? '';
      MrDealGlobals.lat = _lat ?? 0.0;
      MrDealGlobals.long = _long ?? 0.0;
    });

    if (_registerModel.status == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (contex) => const TabbarPage(
                    initialIndex: 0,
                  )));
    }
    Fluttertoast.showToast(
        msg: _registerModel.message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: shadow_color,
        textColor: black_color,
        fontSize: 16.0);
  }
}
