import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class MapMarkers
{
  List<Marker> markers = new List();
  appState myState;
  MapMarkers(List<Item> rockDetails,  context )
  {
    this.myState=Provider.of<appState>(context, listen: true);
    for(var rock in  rockDetails)
      {
        this.markers.add(CreateMarker(rock));
      }

  }
  Marker CreateMarker(Item rockData)
  {
    return Marker(
        width: 80.0,
        height: 80.0,
        point:  new LatLng(double.parse(rockData.lat), double.parse(rockData.lng)),
        builder: (ctx) => Container(
          child: GestureDetector(
            onTap: () {
              this.myState.url=rockData.url;
              this.myState.rockItem=rockData;

            },
            child: Icon(
              Icons.crop_free,
              color: Colors.pink,
              size: 30.0,
              semanticLabel: 'Rock pointer',
            )),
        ));
  }

}