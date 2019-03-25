import 'package:bloc_provider/bloc_provider.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as c;
import 'package:rxdart/rxdart.dart';

const grey = Color(0xff5E5E5E);
const lightGrey = Color(0xffE3E3E3);
const purple = Color(0xff6E46B8);
const pink = Color(0xffC97CBE);
const green= Color(0xff86D9B0);
const orange = Color(0xffC9A57C);
const red = Color(0xffC97C7C);

class AQ {
  var city, aqi, cat, reco, color, asset;
  AQ.fJ(j): aqi = j['data']['indexes']['baqi']['aqi'], cat = j['data']['indexes']['baqi']['category'], reco = j['data']['health_recommendations']['general_population'];
}

main() => runApp(MaterialApp(
  theme: ThemeData(fontFamily: 'Averta', scaffoldBackgroundColor: purple),
  home: BlocProvider<NavBloc>(creator: (_c, _b) => NavBloc(),child: Scaffold(resizeToAvoidBottomPadding: false,body: CurrentView()))
));

class NavBloc implements Bloc {
  ReplaySubject<Widget> _viewController = ReplaySubject<Widget>();
  Sink<Widget> get _inView => _viewController.sink;
  Stream<Widget> get outView => _viewController.stream;
  NavBloc() {
    var x = 0;
    accelerometerEvents.listen((e) {
      if (e.x > x + 30) _inView.add(LoadView());
    });
  }
  showResV(aq) => _inView.add(ResultView(aq));
  dispose() => _viewController.close();
}

class CurrentView extends StatelessWidget {
  build(c) {
    var nB = BlocProvider.of<NavBloc>(c);
    return StreamBuilder(stream: nB.outView, initialData: HomeView(),builder: (c, s) => s.data);
  }
}

class LoadView extends StatelessWidget {
  build(c) {
    var nB = BlocProvider.of<NavBloc>(c);
    return FutureBuilder(future: getAQ(), builder: (c, s) {
			if (s.hasData) nB.showResV(s.data);
			return SvgPicture.asset('assets/load.svg',	fit: BoxFit.fitHeight,);
		});
  }

  getAQ() async {
    var loc = await Location().getLocation();
    var r = await http.get('https://api.breezometer.com/air-quality/v2/current-conditions?lat=${loc.latitude}&lon=${loc.longitude}&key=adf7c0d3e70441959f06a59d772190b0&features=breezometer_aqi,health_recommendations');
    var r2 = await http.get('http://nominatim.openstreetmap.org/reverse?format=json&lat=${loc.latitude}&lon=${loc.longitude}');
    AQ aq = AQ.fJ(c.jsonDecode(r.body));
    aq.color = aq.aqi >= 60 ? green : (aq.aqi < 40 ? red : orange);
    aq.asset = aq.aqi >= 60 ? 'assets/1.flr' : (aq.aqi < 40 ? 'assets/3.flr' : 'assets/2.flr');
    var a = c.jsonDecode(r2.body)['address'];
    aq.city = a['city'] != null ? a['city'] : (a['village'] != null ? a['village'] : 'N/A');
  
    return aq;
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SvgPicture.asset('assets/home.svg',fit: BoxFit.fitHeight,),
      FlareActor("assets/shake.flr",animation: "shake",)
  ]);
  }
}

class ResultView extends StatelessWidget {
  final AQ aq;
  ResultView(this.aq);
  build(BuildContext context) {
    var dec = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.horizontal(right: Radius.circular(10)));
    return Scaffold(
      backgroundColor: aq.color,
      body: Stack(children: [
        FlareActor(aq.asset, fit:BoxFit.fitHeight, animation: 'move'),
        Positioned( bottom: 30, left: 50,right: 50,child: Container( height: 100,child: FlareActor("assets/shake2.flr", animation: "shake",))),
        SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 20, right: 75),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: dec,
            child: Row(children: [
              SvgPicture.asset('assets/p.svg', height: 30, color: grey,),
              SizedBox( width: 15,),
              Text(aq.city,style: TextStyle(fontSize: 26,fontWeight: FontWeight.w600, color: grey))])),
          Container(
            padding: EdgeInsets.only(top: 50,bottom: 50, left: 16, right: 32),
            margin: EdgeInsets.only(right: 75),
            decoration: dec,child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${aq.aqi}/100',style: TextStyle(color: aq.color, fontSize: 26, fontWeight: FontWeight.w800)),
              SizedBox(height: 10),
              Text( aq.cat, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),),
              SizedBox( height: 10),
              Row(children: <Widget>[star(aq.color, true), star(aq.color, aq.aqi > 25), star(aq.color, aq.aqi > 50), star(aq.color, aq.aqi > 75)],),
              SizedBox( height: 40),
              Text(aq.reco, style:TextStyle(color: grey, fontWeight: FontWeight.w200, fontSize: 15)),
      ]))]))]));
    }
}


Widget star(color, isColored) => Container(padding:EdgeInsets.only(right: 10), child:SvgPicture.asset('assets/star.svg',color: isColored ? color:lightGrey));
