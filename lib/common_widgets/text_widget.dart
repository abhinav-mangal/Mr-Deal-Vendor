// import 'package:citypoints_mobile_app/hotel_module/search_hotels/hotel_search_list/view/myfamily_module/addfamily_memeber.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final double? textScaleFactor;
  final Color? color;
  final FontWeight? weight;
  final bool? softwrap;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final fontfamily;
  final letterSpacing;
  final overflow;
  final maxLines;
  final toUpperCase;
  final foreground;
  final style;
  final double? textScalFactor;

  const TextWidget(
      {Key? key,
      required this.text,
      this.size,
      this.color,
      this.weight,
      this.softwrap,
      this.alignment,
      this.decoration,
      this.letterSpacing,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.toUpperCase,
      this.fontfamily,
      this.foreground,
      this.style,
      this.textScalFactor,
      this.textScaleFactor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      toUpperCase == true ? text.toUpperCase() : text,
      softWrap: softwrap,
      textAlign: alignment,
      overflow: overflow,
      maxLines: maxLines,
      textScaleFactor: textScalFactor ?? 1.0,
      style: TextStyle(
          fontSize: size,
          decoration: decoration,
          color: color,
          fontWeight: weight,
          fontFamily: "Poppins",
          foreground: foreground,
          letterSpacing: letterSpacing,
          fontStyle: style),
    );
  }
}
