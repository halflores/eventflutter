import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventflutter/theme/color.dart';

class BottomBarItem extends StatelessWidget {
  const BottomBarItem(this.icon, this.title,
      {Key? key,
      this.onTap,
      this.color = Colors.black,
      this.activeColor = primary,
      this.isActive = false,
      this.isNotified = false})
      : super(key: key);
  final String icon;
  final String title;
  final Color color;
  final Color activeColor;
  final bool isNotified;
  final bool isActive;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color:
                  isActive ? bottomBarColor.withOpacity(1) : Colors.transparent,
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: shadowColor.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
              ],
            ),
            child: SvgPicture.asset(
              icon,
              color: isActive ? activeColor : color,
              width: 23,
              height: 23,
            ),
          ),
        ]),
      ),
    );
  }
}
