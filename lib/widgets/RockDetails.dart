import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:tuple/tuple.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../dataProvider/DataLoader.dart';

//import 'package:user_location/user_location.dart';

class RockDetails extends StatelessWidget {
  final Item rockData;
  RockDetails({Key key, @required this.rockData }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (rockData == null){return null;}

    return Scaffold(
      appBar: AppBar(
          title: Text( rockData.title)
      ),
      body: Container(
        child: ListView(
            children:[

              RockStats(context, rockData),
              RaisedButton(
                onPressed: () => MapsLauncher.launchCoordinates(
                    double.parse(rockData.lat), double.parse(rockData.lng )),
                child: Text('Navigate'),
              ),
              RaisedButton(
                onPressed: () => _launchURL(context, rockData.url),

                child: Text('Open in external browser'),
              ),

            ]
        ),
      ),
    );
  }
}



Widget RockGpsDetails (BuildContext context, String gps_lat, String gps_lng ){

  return Container(
     // padding: EdgeInsets.fromLTRB(10,10,10,0),
  height: 100,
  width: double.maxFinite,
  child:
       Column(

           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: _buildChildGpsDetailsElement(context,gps_lat,gps_lng)
       )
  );
}


Widget RockStats(context, Rock rockItem){
  return FutureBuilder<List<Tuple2<String, String>>>(

      future: _getRockStatsFromRockItem(rockItem),
      builder: (context,   snapshot) {
        if (snapshot.hasData) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: _buildChildRouteElement(context,snapshot.data)
          );
//
        } else {
          return CircularProgressIndicator();
        }
      }
  );
}



List<Widget> _buildChildGpsDetailsElement(BuildContext context,String gps_lat,String gps_lng)
{
  List<Widget> RockGpsDetails = new List();

  RockGpsDetails.add(Row(
    children: <Widget>[
      Center(
        child:
        RaisedButton(
          onPressed: () => MapsLauncher.launchCoordinates(
              double.parse(gps_lat), double.parse(gps_lng)),
          child: Text('Open in Map App'),
        )

      ),
    ],

  ));
  return RockGpsDetails;

}

List<Widget> _buildChildRouteElement(BuildContext context, List<Tuple2<String, String>> routeStats)
{
  List<Widget> routeStatsWidgetsRouteLevel = new List();
  List<Widget> routeStatsWidgetsRouteAmmount = new List();
  for (var element in routeStats)
  {
    routeStatsWidgetsRouteLevel.add( Container(
        color: Colors.blue,
        height: 40,
        width: 20,
        child: Center(
          child: Text(
            element.item1,
            textAlign: TextAlign.center,
          ),
        )));
    routeStatsWidgetsRouteAmmount.add( Container(
        color: Colors.blue,
        height: 40,
        width: 20,
        child:
          Center(
            child: Text(
              element.item2,
              textAlign: TextAlign.center,
            ),
    )));
  }
  List<Widget> RouteStatsStripe = new List();
  RouteStatsStripe.add(Container(
      color: Colors.blue,
      child: Row(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  routeStatsWidgetsRouteLevel)));
  RouteStatsStripe.add(Container(
      color: Colors.blue,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: routeStatsWidgetsRouteAmmount)));

  return RouteStatsStripe;
}


Future<List<Tuple2<String, String>>> _getRockStatsFromRockItem(Rock rockItem) async {
  List<Tuple2<String, String>> routes = List();
  for (var item in rockItem.routesStats.keys)
    {
      var current_route =Tuple2<String, String>(item, rockItem.routesStats[item]);
      routes.add(current_route);
    }
  return routes;


}

_launchURL(BuildContext context,String url) async {
  const baseUrl = "http://topo.portalgorski.pl/";
  String urlToLoad = baseUrl+url;

  if (await canLaunch(urlToLoad)) {
    await launch(urlToLoad);
  } else {
    throw 'Could not launch $urlToLoad';
  }
}
