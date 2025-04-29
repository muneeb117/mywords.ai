import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final paddingTop = MediaQuery.paddingOf(context).top;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      color: const Color(0xff601FBE),
      child: Stack(
        children: [
          Positioned(right: 0, top: paddingTop + 27, child: SvgPicture.asset('assets/images/svg/ic_splash_circle_right.svg', height: 170)),
          Positioned(left: 0, top: paddingTop + 130, child: SvgPicture.asset('assets/images/svg/ic_splash_circle_left.svg', height: 170)),
          Center(child: Image.asset('assets/images/png/img_splash.png', height: 110, width: 145)),
        ],
      ),
    );
  }
}
