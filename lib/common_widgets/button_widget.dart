import 'package:flutter/material.dart';

import 'colors_widget.dart';

class GradientButtonWidget extends StatelessWidget {
  final EdgeInsets? padding;
  final Color? color;
  final Color? disabledColor;
  final VoidCallback onTap;
  final Widget? child;
  final ShapeBorder? shape;

  final String? buttonText;
  final Color? textColor;
  final double? size;

  final BoxShadow? shadowColor;
  const GradientButtonWidget(
      {Key? key,
      this.padding,
      this.color,
      required this.onTap,
      this.disabledColor,
      this.buttonText,
      this.textColor,
      this.size,
      this.child,
      this.shape,
      this.shadowColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: shadow_color,
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                spreadRadius: 1.0),
          ],
          color: color ?? const Color(0xff34B1E6).withOpacity(0.8),
          borderRadius: BorderRadius.circular(5)),
      child: MaterialButton(
        padding: padding ?? const EdgeInsets.all(12),
        onPressed: () {
          onTap();
        },
        disabledColor: disabledColor ?? Colors.grey,
        child: child,
        textColor: textColor,
      ),
    );
  }
}
