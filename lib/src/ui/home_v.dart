import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            'a/shake.svg',
            height: 200,
          ),
        ],
      ),
    );
  }
}
