import 'package:bloc_provider/bloc_provider.dart';
import 'package:oro/src/app.dart';
import 'package:oro/src/ui/res_v.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sensors/sensors.dart';

class NBloc implements Bloc {
  var _vC = ReplaySubject();
  get _inV => _vC.sink;
  get outV => _vC.stream;
  NBloc() {
    var x = 0;
    accelerometerEvents.listen((e) {
      if (e.x > x + 30) _inV.add(LoadV());
    });
  }
  showResV(aq) {
    _inV.add(resultV(aq));
  }

  dispose() {
    _vC.close();
  }
}
