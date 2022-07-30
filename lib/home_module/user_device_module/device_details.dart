import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mr_deal_app/common_widgets/colors_widget.dart';
import 'package:mr_deal_app/common_widgets/font_size.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';
import 'package:mr_deal_app/common_widgets/text_widget.dart';

import '../home_model.dart';

class DeviceDetails extends StatefulWidget {
  final SeriesModel? seriesModel;
  final String? bNm;
  final String? sNm;
  const DeviceDetails(
      {Key? key,
      required this.seriesModel,
      required this.bNm,
      required this.sNm})
      : super(key: key);

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  Widget _appbar() {
    return AppBar(
      backgroundColor: theme_color,
      centerTitle: false,
      automaticallyImplyLeading: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[Color(0xff0e2c94), Color(0xff4abcf2)]),
        ),
      ),
      title: const TextWidget(
        text: 'Device Details',
        size: text_size_18,
        color: white_color,
      ),
    );
  }

  Widget _image() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
          imageUrl: widget.seriesModel?.imgUrl ?? '',
          fit: BoxFit.contain,
          placeholder: (context, url) => const Loader(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),

        // CachedNetworkImage(
        //   imageUrl: widget.seriesModel?.imgUrl ?? '',
        //   fit: BoxFit.fill,
        //   placeholder: (context, url) => const Loader(),
        //   errorWidget: (context, url, error) => const Icon(Icons.error),
        // ),
      ),
    );
  }

  Widget _deviceDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: 'Brand : ${widget.bNm ?? ''}',
            size: text_size_18,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: 'Series : ${widget.sNm ?? ''}',
            size: text_size_18,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text: 'Model : ${widget.seriesModel?.mName ?? ''}',
            size: text_size_18,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text:
                'Amoled Display Price : ${widget.seriesModel?.priceAmoled ?? ''}',
            size: text_size_18,
            weight: FontWeight.w400,
          ),
          const SizedBox(
            height: 20,
          ),
          TextWidget(
            text:
                'Normal Display Price : ${widget.seriesModel?.priceNormal ?? ''}',
            size: text_size_18,
            weight: FontWeight.w400,
          )
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height - 80,
      width: MediaQuery.of(context).size.width,
      color: white_color,
      child: Column(
        children: [_image(), _deviceDetails()],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.seriesModel!.imgUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              appBar: PreferredSize(
                  child: _appbar(), preferredSize: const Size.fromHeight(60)),
              body: SingleChildScrollView(child: _body()),
            )));
  }
}
