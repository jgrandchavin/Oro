import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:oro/src/blocs/nav_blc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:oro/src/models/aq.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as c;

app() {
  return MaterialApp(
    theme: ThemeData(
        fontFamily: 'Averta', scaffoldBackgroundColor: Color(0xff6E46B8)),
    home: BlocProvider<NBloc>(
      creator: (_c, _b) => NBloc(),
      child: Scaffold(
        body: CurV(),
      ),
    ),
  );
}

class CurV extends StatelessWidget {
  build(c) {
    var nB = BlocProvider.of<NBloc>(c);
    return StreamBuilder(
      stream: nB.outV,
      initialData: homeV(),
      builder: (c, s) {
        return s.data;
      },
    );
  }
}

class LoadV extends StatelessWidget {
  build(c) {
    final nB = BlocProvider.of<NBloc>(c);
    return FutureBuilder(
        future: getAQ(),
        builder: (c, s) {
          if (s.hasData) nB.showResV(s.data);
          return Center(
            child: Text('Loading'),
          );
        });
  }

  getAQ() async {
    var loc = await Location().getLocation();
    var r = await http.get(
        'https://api.breezometer.com/air-quality/v2/current-conditions?lat=${loc.latitude}&lon=${loc.longitude}&key=3569483c7d154009953713547672eb46&features=breezometer_aqi,health_recommendations');
    var r2 = await http.get(
        'http://nominatim.openstreetmap.org/reverse?format=json&lat=${loc.latitude}&lon=${loc.longitude}');
    AQ aq = AQ.fJ(c.jsonDecode(r.body));
    aq.color = aq.aqi >= 60
        ? Color(0xff86D9B0)
        : (aq.aqi < 40 ? Color(0xffC97C7C) : Color(0xffC9A57C));
    aq.asset = aq.aqi >= 60 ? 'a/1.svg' : (aq.aqi < 40 ? 'a/3.svg' : 'a/2.svg');
    var a = c.jsonDecode(r2.body)['address'];
    aq.city = a['city'] != null ? a['city'] : a['village'];
    return aq;
  }
}

homeV() {
  return Center(
    child: SvgPicture.asset(
      'a/s.svg',
      height: 200,
    ),
  );
}
