import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class MapMarkers {
  List<Marker> markers = new List();

  MapMarkers(Map<String, dynamic> rockDetails, context,
      Map<String, bool> filtersState, Map<String, dynamic> filtersContent) {

    Map<String,Rock> rocks = rockDetails;
    log(rocks["246"].title);
    log(rocks["246"].routesStatsSimplified.toString());
    List<String> rockIdToDisplay = new List();
    rockIdToDisplay.addAll(rocks.keys);

    if (filtersState["showOnlyFavorites"] == true) {

      for (var rockId in rocks.keys) {
        if (filtersContent["favorites"].contains(rockId) != true) {
          rockIdToDisplay.remove(rockId);
        }
      }
    }
    List<String> routeFilters = [
      "includeWithIII",
      "includeWithIV",
      "includeWithV",
      "includeWithVI"
    ];
    for (var filter in routeFilters) {
      if (filtersState[filter] == true) {
        String currentRouteLevel = filtersContent[filter];
        for (var rock in rocks.values) {
          if (rock.routesStatsSimplified[currentRouteLevel] == 0)
            {
              rockIdToDisplay.remove(rock.id);
            }
        }
      }
    }

    for (var rock in rockDetails.values) {
      if (rockIdToDisplay.contains(rock.id)) {
        this.markers.add(CreateMarker(rock));
      }
    }
  }

  Marker CreateMarker(Item rockData) {
    return RockMarker(
        rock: RockContainer(
          RockData: rockData,
        ));
  }
}

class RockContainer {
  static const double size = 25;

  RockContainer({this.RockData});

  final Item RockData;
}

class RockMarker extends Marker {
  RockMarker({@required this.rock})
      : super(
      anchorPos: AnchorPos.align(AnchorAlign.top),
      height: RockContainer.size,
      width: RockContainer.size,
      point: new LatLng(double.parse(rock.RockData.lat),
          double.parse(rock.RockData.lng)),
      builder: (BuildContext ctx) =>
          Icon(
            Icons.crop_free,
            color: Colors.pink,
            size: 30.0,
            semanticLabel: 'Rock pointer',
          ));

  final RockContainer rock;
}
