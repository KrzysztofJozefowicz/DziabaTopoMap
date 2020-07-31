import 'package:flutter/material.dart';
import '../widgets/MapMarkers.dart';
import '../dataProvider/RockLoader.dart';
import 'dart:developer';

Widget createColorBoxes(dynamic rockData) {
  dynamic rock;
  if (rockData is RockMarker) {
    rock = rockData.rock.RockData;
  }
  if (rockData is Rock) {
    rock = rockData;
  }

  List<Widget> routesBoxesStripe = new List();
  List<Widget> routesLegendStripe = new List();

  Map<String, Color> routeToColorMappings = {
    "III": Colors.lightGreen,
    "IV": Colors.cyan,
    "V": Colors.yellow,
    "VI": Colors.pink[100],
    "VI.1": Colors.pink[200],
    "VI.2": Colors.pink[300],
    "VI.3": Colors.pink[400],
    "VI.4": Colors.pink[500],
    "VI.5": Colors.pink[600],
    "VI.6": Colors.pink[700],
    "VI.7": Colors.pink[800],
    "VI.8": Colors.pink[900],
  };

  for (var route in rock.routesStatsSimplified.keys) {
    double boxHeight = 1.0;
    Color boxColor = routeToColorMappings[route];
    if (rock.routesStatsSimplified[route] > 0 && rock.routesStatsSimplified[route] < 3) {
      boxHeight = 10.0;
    }
    if (rock.routesStatsSimplified[route] >= 3 && rock.routesStatsSimplified[route] < 6) {
      boxHeight = 20.0;
    }
    if (rock.routesStatsSimplified[route] >= 6 && rock.routesStatsSimplified[route] < 10) {
      boxHeight = 30.0;
    }
    if (rock.routesStatsSimplified[route] >= 10) {
      boxHeight = 42.0;
    }
    routesBoxesStripe.add(Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(width: 20.0, height: boxHeight, child: DecoratedBox(decoration: BoxDecoration(color: boxColor))),
        SizedBox(
            width: 20.0,
            height: 10.0,
            child: Center(
                child: Text(
//                route + ":" + rock.routesStatsSimplified[route].toString(),
                    rock.routesStatsSimplified[route].toString(),
                    style: TextStyle(color: Colors.black, fontSize: 10)))),
      ],
    ));
    routesLegendStripe.add(SizedBox(
        width: 20.0,
        height: 10.0,
        child: Center(child: Text(route, style: TextStyle(color: Colors.black, fontSize: 10)))));
  }

  //return routesBoxesStripe;
  return Column(
    children: [
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: routesBoxesStripe),
      Row(children: routesLegendStripe)
    ],
  );
}
