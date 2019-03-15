import 'package:flutter/material.dart';

class AQ {
  String city;
  int aqi;
  String cat;
  String reco;
  Color color;
  String asset;

  AQ.fromJson(Map<String, dynamic> json)
      : aqi = json['data']['indexes']['baqi']['aqi'],
        cat = json['data']['indexes']['baqi']['category'],
        reco = json['data']['health_recommendations']['general_population'];
}
