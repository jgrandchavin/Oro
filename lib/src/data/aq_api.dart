import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'dart:convert' as convert;
import 'package:oro/src/models/aq.dart';

class AQApi {
  Future<AQ> getAQ() async {
    LocationData curLoc = await Location().getLocation();
    var resp = await http.get(
        'https://api.breezometer.com/air-quality/v2/current-conditions?lat=${curLoc.latitude}&lon=${curLoc.longitude}&key=3569483c7d154009953713547672eb46&features=breezometer_aqi,health_recommendations');
    var resp2 = await http.get(
        'http://nominatim.openstreetmap.org/reverse?format=json&lat=${curLoc.latitude}&lon=${curLoc.longitude}&zoom=18&addressdetails=1');
    AQ aq = AQ.fromJson(convert.jsonDecode(resp.body));
    if (aq.aqi >= 60) {
      aq.color = Color(0xff86D9B0);
      aq.asset = 'a/1.svg';
    } else if (aq.aqi < 40) {
      aq.color = Color(0xffC97C7C);
      aq.asset = 'a/3.svg';
    } else {
      aq.color = Color(0xffC9A57C);
      aq.asset = 'a/2.svg';
    }
    aq.city = convert.jsonDecode(resp2.body)['address']['city'];
    return aq;
  }
}
