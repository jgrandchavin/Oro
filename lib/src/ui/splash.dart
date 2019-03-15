import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SvgPicture.asset(
          'assets/logo.svg',
          color: Colors.white,
          width: 100,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'ORO',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
