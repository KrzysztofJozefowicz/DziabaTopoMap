import '../states/AppState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../dataProvider/RockLoader.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class MapMarkers {
  List<Marker> markers = new List();

  MapMarkers(Set<Item> rocksItemsToDisplay ) {

    for (var item in rocksItemsToDisplay)
      {
        this.markers.add(createMarker(item));
      }

    }


  Marker createMarker(Item rockData) {
    return RockMarker(
        rock: RockContainer(
          rockData: rockData,
        ));
  }
}

class RockContainer {
  static const double size = 100;

  RockContainer({this.rockData});

  final Item rockData;
}

class RockMarker extends Marker {
  RockMarker({@required this.rock})
      : super(
      anchorPos: AnchorPos.align(AnchorAlign.top),
      height: RockContainer.size,
      width: RockContainer.size,
      point: new LatLng(double.parse(rock.rockData.lat),
          double.parse(rock.rockData.lng)),
      builder: (BuildContext ctx) =>
          Column(
            children: [
              Icon(
                Icons.crop_free,
                color: Colors.pink,
                size: 30.0,
                semanticLabel: 'Rock pointer',
              ),
              Text(rock.rockData.title , textAlign: TextAlign.center, style: TextStyle(color: Colors.black))

            ]
          )
          );

  final RockContainer rock;
}
