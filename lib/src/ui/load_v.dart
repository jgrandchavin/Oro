import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:oro/src/blocs/nav_blc.dart';
import 'package:oro/src/data/aq_api.dart';
import 'package:oro/src/models/aq.dart';

class LoadingV extends StatelessWidget {
  final AQApi _airQualityApi = AQApi();
  @override
  Widget build(BuildContext context) {
    final NavBloc navigationBloc = BlocProvider.of<NavBloc>(context);
    return SafeArea(
      child: FutureBuilder<AQ>(
          future: _airQualityApi.getAQ(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text(snapshot.error);
            if (snapshot.hasData) {
              navigationBloc.showResultView(snapshot.data);
              return Container();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
