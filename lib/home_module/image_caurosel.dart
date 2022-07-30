import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mr_deal_app/common_widgets/loader.dart';

import 'home_model.dart';

class ImageSlider extends StatefulWidget {
  final List<ImageData>? imgListData;
  const ImageSlider({Key? key, required this.imgListData}) : super(key: key);

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  late List imgList = [];
  List<ImageData>? _imgListData;
  @override
  void initState() {
    super.initState();
    _imgListData = widget.imgListData;

    for (var i = 0; i < (_imgListData?.length ?? 0); i++) {
      imgList.add(_imgListData![i].url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
            child: CarouselSlider(
          options: CarouselOptions(
            // autoPlay: true,
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
          ),
          items: imgList
              .map((item) =>
                  // Center(
                  //           child: Image.network(
                  //             item,
                  //             fit: BoxFit.cover,
                  //           ),
                  //         )

                  Container(
                    child: CachedNetworkImage(
                      imageUrl: "$item",
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Loader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ))
              .toList(),
        )),
      ),
    );
  }
}
