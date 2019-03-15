import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oro/src/models/aq.dart';

class ResultV extends StatelessWidget {
  final AQ airQuality;

  ResultV(this.airQuality);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: airQuality.color,
      body: Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              child: SvgPicture.asset(airQuality.asset, fit: BoxFit.fitWidth)),
          Positioned(
              bottom: 0,
              left: 50,
              right: 50,
              child: SafeArea(
                child: SvgPicture.asset(
                  'assets/shake.svg',
                  fit: BoxFit.fitHeight,
                  height: 60,
                ),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: 50, top: 75),
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/place.svg',
                        color: Color(0xff5E5E5E),
                        height: 30,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        airQuality.city,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff5E5E5E),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(right: 50, top: 50),
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      '${airQuality.aqi} / 100',
                      style: TextStyle(
                          color: airQuality.color,
                          fontSize: 26,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${airQuality.cat}',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${airQuality.reco}',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w100),
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
}
