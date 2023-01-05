import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventflutter/theme/color.dart';
import 'package:eventflutter/theme/color.dart' as color;

class FavoriteBox extends StatelessWidget {
  const FavoriteBox(
      {Key? key,
      this.bgColor = red,
      this.onTap,
      this.isFavorited = false,
      this.borderColor = Colors.transparent,
      this.radius = 50,
      this.size = 22,
      this.padding = 2})
      : super(key: key);
  final Color borderColor;
  final Color? bgColor;
  final bool isFavorited;
  final double radius;
  final double size;
  final double padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        padding: EdgeInsets.all(padding),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
            color: isFavorited ? red : primary.withOpacity(.5),
            shape: BoxShape.circle),
        child: isFavorited
            ? const Icon(
                Icons.favorite_rounded,
                size: 30,
                color: color.appBarColor,
              )
            : const Icon(
                Icons.favorite_border,
                size: 30,
                color: color.appBarColor,
              ),
      ),
    );
  }
}
