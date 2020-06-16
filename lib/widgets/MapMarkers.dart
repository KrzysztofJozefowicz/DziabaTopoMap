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
    //this.myState=Provider.of<appState>(context, listen: true);
    for(var rock in  rockDetails)
      {
        this.markers.add(CreateMarker(rock));
      }

  }
  Marker CreateMarker(Item rockData)
  {
    return RockMarker(rock: Rock(
      RockData: rockData,
      )
    );

  }

}
class Rock {
  static const double size = 25;
  Rock(
      {this.RockData
      });
  final Item RockData;


}

class RockMarker extends Marker {
  RockMarker({@required this.rock})
      : super(
    anchorPos: AnchorPos.align(AnchorAlign.top),
    height: Rock.size,
    width: Rock.size,
    point:  new LatLng(double.parse(rock.RockData.lat), double.parse(rock.RockData.lng)),
    builder: (BuildContext ctx) =>
            Icon(
              Icons.crop_free,
              color: Colors.pink,
              size: 30.0,
              semanticLabel: 'Rock pointer',
            )
  );

  final Rock rock;
}