import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

resultV(aq) {
  return Scaffold(
    backgroundColor: aq.color,
    body: Stack(
      children: [
        Positioned(
            bottom: 0, child: SvgPicture.asset(aq.asset, fit: BoxFit.fitWidth)),
        Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: SvgPicture.asset(
              'a/s.svg',
              height: 60,
            )),
        Column(
          children: [
            Container(
                margin: EdgeInsets.only(right: 50, top: 75),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                color: Colors.white,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'a/place.svg',
                      height: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      aq.city,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(right: 50, top: 50),
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    '${aq.aqi} / 100',
                    style: TextStyle(
                        color: aq.color,
                        fontSize: 26,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${aq.cat}',
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    '${aq.reco}',
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
