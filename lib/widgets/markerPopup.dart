import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/MapMarkers.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';


class markerPopup extends StatefulWidget {
  final Marker marker;

  markerPopup(this.marker, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _markerPopupState(this.marker);
}

class _markerPopupState extends State<markerPopup> {
  final RockMarker _marker;

  _markerPopupState(this._marker);

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: () => setState(() {
          myState.rockItem = _marker.rock.RockData;
        }),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(minWidth: 50, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: routesColorBar(context),
        ),
      ),
    );
  }
  List<Widget> routesColorBar(BuildContext context)
  {
    var myState = Provider.of<appState>(context, listen: true);
    List<Widget> RouteStatsStripe = new List();
    RouteStatsStripe.add(Text(
      _marker.rock.RockData.title,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,      ),    ));

    RouteStatsStripe.add(Container(
        color: Colors.transparent,
        child: Row(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:  _createColorBoxes(_marker))));
    RouteStatsStripe.add(Container(
        color: Colors.transparent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _createBoxLegends(_marker))));
    RouteStatsStripe.add(Container(
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Add to favorites"),
            ],
          ),
          onTap: () => setState(() {
            //if in favorites , remove from favirites
            // if not in favorites add
            // color background
            myState.ClearRockItem();
          }),
        )

    ));



    return RouteStatsStripe;
  }

  _createBoxLegends ( RockMarker rockData)
  {
    List<Widget> routesLegendsStripe = new List();
    Rock rock = rockData.rock.RockData;
    Map<String,int> routesCount =_countRouts(rock);

    for (var route in routesCount.keys){
      routesLegendsStripe.add(
          SizedBox(
            width: 42.0,
            height: 42.0,
            child: Text(route+":"+routesCount[route].toString()),
          )
      );

    }

  return routesLegendsStripe;
  }
  _createColorBoxes( RockMarker rockData)
  {

    List<Widget> routesBoxesStripe = new List();
    Rock rock = rockData.rock.RockData;
    Map<String,int> routesCount =_countRouts(rock);
    Map<String,Color> routeToColorMappings={"III": Colors.lightGreen, "IV": Colors.cyan, "V": Colors.orange, "VI":Colors.red};

    for (var route in routesCount.keys)
    {
      double height =1.0;
      Color color = routeToColorMappings[route];
      if (routesCount[route] >0 && routesCount[route] <3)
        {height = 10.0; }
      if (routesCount[route] >=3 && routesCount[route] <6)
      {height = 20.0;}
      if (routesCount[route] >=6 && routesCount[route] <10)
      {height = 30.0;}
      if (routesCount[route]  >=10 )
      {height = 42.0;}

      routesBoxesStripe.add(

          SizedBox(
            width: 42.0,
            height: height,
                child:
                  DecoratedBox(
                  decoration:  BoxDecoration(
                  color: color
                  ))
            //child: Text(route+":"+routesCount[route].toString()),
          )
      );

    }
    return routesBoxesStripe;
  }
  Map<String,int> _countRouts(Rock rock)
  {
    Map<String,int> routesCount = {"III":0, 'IV':0 ,'V':0 , 'VI':0};
    for (var element in rock.routesStats.keys)
    {
      if (element.contains(new RegExp(r'II.*')) || element.contains(new RegExp(r'III.*')))
      {
        routesCount['III']+=int.parse(rock.routesStats[element]);
        continue;
      }

      if (element.contains(new RegExp(r'IV.*')))
      {
        routesCount['IV']+=int.parse(rock.routesStats[element]);
        continue;
      }

      if (element.contains(new RegExp(r'VI.*')))
      {
        routesCount['VI']+=int.parse(rock.routesStats[element]);
        continue;
      }
      if (element.contains(new RegExp(r'V.*')))
      {
        routesCount['V']+=int.parse(rock.routesStats[element]);
        continue;
      }
    }
    return routesCount;
  }
}




