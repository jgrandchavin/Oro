import 'package:flutter/material.dart';
import 'package:oro/src/blocs/nav_blc.dart';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:oro/src/ui/splash.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Averta', scaffoldBackgroundColor: Color(0xff6E46B8)),
      home: BlocProvider<NavBloc>(
        creator: (_context, _bag) => NavBloc(),
        child: Scaffold(
          body: CurrentView(),
        ),
      ),
    );
  }
}

class CurrentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavBloc navBloc = BlocProvider.of<NavBloc>(context);
    return StreamBuilder<Widget>(
      stream: navBloc.outView,
      initialData: Splash(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data;
      },
    );
  }
}
