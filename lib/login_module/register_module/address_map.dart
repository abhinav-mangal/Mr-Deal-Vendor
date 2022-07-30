import 'dart:async';
import 'package:collection/src/iterable_extensions.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as locationImport;
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/globals.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';

class AddressMap extends StatefulWidget {
  final route;

  const AddressMap({
    Key? key,
    this.route,
  }) : super(key: key);

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  static final LatLng _center = LatLng(MrDealGlobals.lat, MrDealGlobals.long);
  LatLng _lastMapPosition = _center;
  static const kGoogleApiKey = "AIzaSyDfGXj8CkiwHqpJ40xLq7mdwi60Iwc3C_0";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  GoogleMapController? mapController;
  GoogleMapsGeocoding _geocoding = GoogleMapsGeocoding(apiKey: kGoogleApiKey);
  TextEditingController myController = new TextEditingController();

  var latitude;
  var longitude;
  var city;
  String country = "";
  var area;
  String? address;
  var locality;
  var streetaddress;
  var start;
  var pincode;
  Position? _currentPosition;
  String? _currentAddress;
  var move = false;
  var _zoom = 25.0;
  var focusNode = FocusNode();
  String? error;

  @override
  void initState() {
    super.initState();
    myController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  _getCurrentLocation() {
    locationImport.Location().getLocation().then((value) {
      _lastMapPosition = LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0);
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 270.0,
          target: _lastMapPosition,
          tilt: 30.0,
          zoom: 20.0,
        ),
      ));

      setState(() {});
    });
  }

  showaddressoption() {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.1),
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(60),
                decoration: BoxDecoration(
                    color: theme_color.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: TextWidget(
                        alignment: TextAlign.center,
                        text: "We Currently Only Deliver In UAE",
                        color: white_color,
                        softwrap: true,
                        weight: FontWeight.bold,
                        size: text_size_18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<List<Prediction>> fetchPlaces(String query) async {
    final _fetch = await _places.autocomplete(query, language: 'en');
    return _fetch.predictions;
  }

  Future<void> fetchOnCameraMove(LatLng location) async {
    final _location = Location(lat: location.latitude, lng: location.longitude);
    final _data = await _geocoding.searchByLocation(_location, language: 'en');

    if (_data == null || _data.results.isEmpty && country == "") {
      showaddressoption();
    } else {
      final detail = _data.results.isNotEmpty ? _data.results.first : null;

      if (detail != null) {
        address = detail.formattedAddress;
        city = detail.addressComponents
            .firstWhere((e) => e.types.contains("locality"))
            .longName;
        area = detail.addressComponents
            .firstWhere((e) => e.types.contains("sublocality_level_1"))
            .longName;
        streetaddress = "";
        country = detail.addressComponents
            .firstWhere(
              (element) => element.types.contains("country"),
            )
            .longName;

        setState(() {});
      }
    }
  }

  Future<Null> displayPrediction(Prediction? p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!, language: 'en');
      double lat = detail.result.geometry!.location.lat;
      double lng = detail.result.geometry!.location.lng;
      print("ooooooo");
      print(detail.result.formattedAddress);

      country = detail.result.addressComponents
              .firstWhereOrNull((element) => element.types.contains("country"))
              ?.longName ??
          "";

      print("country ------ $country");

      city = detail.result.addressComponents
              .firstWhereOrNull((element) => element.types.contains("locality"))
              ?.longName ??
          "";

      area = detail.result.addressComponents
              .firstWhereOrNull(
                  (element) => element.types.contains("sublocality_level_1"))
              ?.longName ??
          "";

      streetaddress = "";
      print("lat - $lat && long - $lng");

      setState(() {
        _lastMapPosition = LatLng(lat, lng);
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target: _lastMapPosition,
            tilt: 30.0,
            zoom: _zoom,
          ),
        ));
        myController.text = detail.result.name.toString();
      });
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    EasyDebounce.debounce('debouncer1', Duration(milliseconds: 500),
        () => fetchOnCameraMove(_lastMapPosition));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0.0,
        target: _lastMapPosition,
        tilt: 0.0,
        zoom: _zoom,
      ),
    ));

    setState(() {
      _getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _map() {
      return GestureDetector(
          child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                  compassEnabled: false,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: _lastMapPosition,
                    zoom: _zoom,
                  ),
                  onCameraMove: _onCameraMove,
                  onMapCreated: _onMapCreated)),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                move
                    ? const CircularProgressIndicator()
                    : const SizedBox(
                        height: 0,
                      ),
                Icon(
                  Icons.share_location_rounded,
                  size: 50,
                  color: red_color.shade600,
                )
              ],
            ),
          )
        ],
      ));
    }

    Widget _seachbar() {
      return Positioned(
        top: 20,
        left: 20,
        right: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: white_color,
                    border: Border.all(width: 0.5, color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(20)),
                child: TypeAheadField<Prediction>(
                  debounceDuration: const Duration(milliseconds: 350),
                  onSuggestionSelected: (p) => displayPrediction(p),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                      offsetX: 30,
                      constraints: const BoxConstraints(maxWidth: 280),
                      color: white_color,
                      borderRadius: BorderRadius.circular(10)),
                  suggestionsCallback: (query) => fetchPlaces(query),
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.terms[0].value),
                    );
                  },
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    focusNode: focusNode,
                    controller: myController,
                    decoration: InputDecoration(
                        prefixIcon: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: Icon(Icons.search,
                                color: Colors.grey.shade400)),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: text_size_14,
                            fontWeight: FontWeight.bold),
                        contentPadding:
                            const EdgeInsets.only(left: 20, top: 10)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                _getCurrentLocation();
              },
              child: const AbsorbPointer(
                child: Icon(
                  Icons.my_location,
                  color: blue_color,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _confirmLocation() {
      return Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: country == ""
                ? () {}
                : () {
                    Map<String, dynamic>? _requiredData = {
                      'lat': _lastMapPosition.latitude,
                      'long': _lastMapPosition.longitude,
                      'address': address
                    };
                    Navigator.pop(context, _requiredData);
                  },
            child: Container(
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: country == "" ? Colors.grey.shade400 : theme_color,

                    // gradient: LinearGradient(
                    //     colors: country == ""
                    //         ? [Colors.grey.shade400, Colors.grey.shade400]
                    //         : [Color(0xff0e2c94), Color(0xff4abcf2)],
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 10,
                      )
                    ]),
                child: const TextWidget(
                  text: "confirm location",
                  color: white_color,
                  weight: FontWeight.bold,
                  size: text_size_16,
                )),
          ));
    }

    Widget _body() {
      return Container(
        color: white_color,
        child: Stack(
          alignment: Alignment.center,
          children: [_map(), _seachbar(), _confirmLocation()],
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: theme_color,
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
                ),
                height: 100,
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 35, 0, 0),
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: white_color,
                          )),
                    ),
                    const Spacer(),
                    const TextWidget(
                      text: "Shop Address",
                      weight: FontWeight.w600,
                      size: text_size_16,
                      color: white_color,
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const TextWidget(
                        text: "Cancel",
                        weight: FontWeight.w600,
                        size: text_size_16,
                        color: white_color,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    )
                  ]),
                ),
              ),
              preferredSize: const Size.fromHeight(50)),
          body: _body(),
        ),
      ),
    );
  }

  Future<locationImport.LocationData> getGeoLocation() async {
    var _location = locationImport.Location();
    //final permissionStatus = await _location.hasPermission();
    var location;
    final servicesStatus = await _location.serviceEnabled();
    if (servicesStatus) {
      final position = await _location
          .getLocation()
          // ignore: null_argument_to_non_null_type
          .timeout(Duration(seconds: 15), onTimeout: () => Future.value(null));
      if ((position.latitude ?? 0) != 0) location = position;
      return location;
    }
    var _permission = await _location.requestPermission();
    if (_permission == locationImport.PermissionStatus.granted) {
      await _location.requestService();
      var servicesStatus = await _location.serviceEnabled();
      if (servicesStatus) {
        return await getGeoLocation();
      }
    }
    // ignore: null_argument_to_non_null_type
    return Future.value(null);
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
