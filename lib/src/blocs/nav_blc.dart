import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:oro/src/models/aq.dart';
import 'package:oro/src/ui/home_v.dart';
import 'package:oro/src/ui/load_v.dart';
import 'package:oro/src/ui/res_v.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';

class NavBloc implements Bloc {
  PublishSubject<Widget> _viewC = PublishSubject<Widget>();
  Sink<Widget> get _inView => _viewC.sink;
  Stream<Widget> get outView => _viewC.stream;
  NavBloc() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      _inView.add(HomeV());
    });
    outView.listen((Widget w) {
      double x = 0;
      if (w.toString() == 'HomeV' || w.toString() == 'ResultV') {
        accelerometerEvents.listen((AccelerometerEvent event) {
          if (event.x > x + 30) _inView.add(LoadingV());
        });
      }
    });
  }
  showResultView(AQ airQuality) {
    _inView.add(ResultV(airQuality));
  }

  @override
  void dispose() {
    _viewC.close();
  }
}
