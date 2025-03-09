import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarIcon extends StatelessWidget {
  NavBarIcon({super.key, required this.imageName});
  String imageName;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      imageName,
      height: 24,
      width: 24,
      fit: BoxFit.scaleDown,
    );
  }
}
