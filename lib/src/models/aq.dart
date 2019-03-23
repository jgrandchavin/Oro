class AQ {
  var city;
  var aqi;
  var cat;
  var reco;
  var color;
  var asset;

  AQ.fJ(j)
      : aqi = j['data']['indexes']['baqi']['aqi'],
        cat = j['data']['indexes']['baqi']['category'],
        reco = j['data']['health_recommendations']['general_population'];
}
