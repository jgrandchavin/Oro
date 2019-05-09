import 'package:bloc_provider/bloc_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as c;
import 'package:rxdart/rxdart.dart';

const grey = Color(0xff5E5E5E);
const lightGrey = Color(0xffE3E3E3);
const purple = Color(0xff6E46B8);
const green = Color(0xff86D9B0);
const orange = Color(0xffC9A57C);
const blue = Color(0xff7CC3C9);
const red = Color(0xffC97C7C);
space(double h, double w) => SizedBox(height: h, width: w);
text(String t, double s, Color c, FontWeight f) =>
    Text(t, style: TextStyle(color: c, fontWeight: f, fontSize: s));
svg(String a, double h, double w, Color c) =>
    SvgPicture.asset(a, color: c, height: h, width: w);
edgeInsests(double t, double b, double r, double l) =>
    EdgeInsets.only(left: l, right: r, top: t, bottom: b);
headerCont(c) => Container(
    padding: edgeInsests(5, 5, 10, 10),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: lightGrey.withOpacity(0.4),
              blurRadius: 1,
              offset: Offset(0, 2))
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
        color: Colors.white),
    child: c);

class AQ {
  var city, aqi, category, catNumb, reco, color, asset, tmp, icon;
  AQ.fJ(j)
      : aqi = j['data']['current']['pollution']['aqius'],
        tmp = j['data']['current']['weather']['tp'],
        icon = 'assets/${j['data']['current']['weather']['ic']}.svg';
}

main() => runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Averta', scaffoldBackgroundColor: purple),
    home: BlocProvider<NavBloc>(
        creator: (c, b) => NavBloc(), child: Scaffold(body: CurrentView()))));

class NavBloc implements Bloc {
  BehaviorSubject<Widget> _viewCtrl = BehaviorSubject<Widget>();
  Sink<Widget> get _inView => _viewCtrl.sink;
  Stream<Widget> get outView => _viewCtrl.stream;
  NavBloc() {
    accelerometerEvents
        .where((e) => e.x > 20 && _viewCtrl.value.toString() != 'LoadView')
        .listen((_) => _inView.add(LoadView()));
  }
  showResV(aq) => _inView.add(ResultView(aq));
  dispose() => _viewCtrl.close();
}

class CurrentView extends StatelessWidget {
  build(c) {
    var nB = BlocProvider.of<NavBloc>(c);
    return StreamBuilder(
        stream: nB.outView, initialData: homeView(), builder: (c, s) => s.data);
  }
}

class LoadView extends StatelessWidget {
  build(c) {
    var nB = BlocProvider.of<NavBloc>(c);
    return FutureBuilder(
        future: getAQ(),
        builder: (c, s) {
          if (s.hasData) nB.showResV(s.data);
          return Stack(
              fit: StackFit.expand,
              children: [SvgPicture.asset('assets/load.svg')]);
        });
  }

  getAQ() async {
    var loc = await Location().getLocation(),
        json =
            await c.jsonDecode(await rootBundle.loadString('assets/text.json')),
        r = await http.get(
            'http://api.airvisual.com/v2/nearest_city?lat=${loc.latitude}&lon=${loc.longitude}&key=qZDARMBt8RLaHyiMd'),
        r2 = await http.get(
            'http://nominatim.openstreetmap.org/reverse?format=json&lat=${loc.latitude}&lon=${loc.longitude}&zoom=10'),
        aq = AQ.fJ(c.jsonDecode(r.body)),
        a = c.jsonDecode(r2.body)['address']['city'];
    aq.catNumb =
        aq.aqi < 31 ? '1' : (aq.aqi < 51 ? '2' : (aq.aqi < 101 ? '3' : '4'));
    aq.color = aq.aqi < 31
        ? blue
        : (aq.aqi < 51 ? green : (aq.aqi < 101 ? orange : red));
    aq.reco = json['reco'][aq.catNumb];
    aq.asset = json['assets'][aq.catNumb];
    aq.city = a != null ? a : 'N/A';
    aq.category = json['quality'][aq.catNumb];
    return aq;
  }
}

homeView() => Stack(fit: StackFit.expand, children: [
      SvgPicture.asset('assets/home.svg'),
      FlareActor('assets/shake.flr', animation: 'shake')
    ]);

class ResultView extends StatelessWidget {
  final aq;
  ResultView(this.aq);
  build(c) {
    var dec = BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.horizontal(right: Radius.circular(10))),
        media = MediaQuery.of(c).size;
    return Scaffold(
        backgroundColor: aq.color,
        body: Stack(fit: StackFit.expand, children: [
          Positioned(
              bottom: 0,
              child: Container(
                  height: media.height * 0.4,
                  width: media.width,
                  child: FlareActor(aq.asset,
                      fit: BoxFit.fitWidth, animation: 'move'))),
          Positioned(
              bottom: 0,
              left: 50,
              right: 50,
              child: Container(
                  height: 100,
                  child: FlareActor('assets/shake2.flr', animation: 'shake'))),
          SafeArea(
              child: Column(children: [
            Container(
                margin: edgeInsests(30, 20, 75, 0),
                padding: edgeInsests(20, 20, 16, 16),
                decoration: dec,
                child: Column(children: [
                  Row(children: [
                    svg('assets/place.svg', 26, 20, grey),
                    space(0, 15),
                    text(aq.city, 26, grey, FontWeight.w600)
                  ]),
                  space(15, 0),
                  Row(children: [
                    headerCont(text('${aq.tmp}°C', 18, grey, FontWeight.w600)),
                    space(0, 10),
                    headerCont(svg(aq.icon, 21, 21, grey))
                  ])
                ])),
            Container(
                padding: edgeInsests(50, 50, 32, 26),
                margin: edgeInsests(0, 0, 75, 0),
                decoration: dec,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            text('${aq.aqi}', 30, aq.color, FontWeight.w800),
                            space(0, 10),
                            text('Air Quality Index', 19, aq.color,
                                FontWeight.w200)
                          ]),
                      space(10, 0),
                      text(aq.category, 20, grey, FontWeight.w600),
                      space(10, 0),
                      Row(children: [
                        star(aq.color, aq.aqi < 101),
                        star(aq.color, aq.aqi < 51),
                        star(aq.color, aq.aqi < 31)
                      ]),
                      space(40, 0),
                      text(aq.reco, 15, grey, FontWeight.w200)
                    ]))
          ]))
        ]));
  }
}

star(color, isColored) => Container(
    padding: edgeInsests(0, 0, 16, 0),
    child: SvgPicture.asset('assets/star.svg',
        color: isColored ? color : lightGrey));
