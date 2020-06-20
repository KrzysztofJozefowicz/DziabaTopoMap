

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
    return Consumer<appState>(builder: (context, favColor, _) {
      return Card(
        color: myState.favColor,
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
    });


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

  List<Widget> routesColorBar(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    List<Widget> RouteStatsStripe = new List();
    RouteStatsStripe.add(Text(
      _marker.rock.RockData.title,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      ),
    ));

    RouteStatsStripe.add(Container(
        color: Colors.transparent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _createColorBoxes(_marker))));
    RouteStatsStripe.add(Container(
        color: Colors.transparent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _createBoxLegends(_marker))));
    RouteStatsStripe.add(_buildFavoriteBar(myState, _marker.rock.RockData.id));

    return RouteStatsStripe;
  }

  Widget _buildFavoriteBar(appState myState, String id) {
    return Container(
        color: myState.favColor,
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[_isInFavorite(myState, id)],
          ),
          onTap: () => setState(() {
            if (myState.IsInFavorites(id)) {
              myState.RemoveFromFavorites(id);
              myState.favColor = Colors.transparent;
              myState.FilterContent["favorites"]=myState.favorites;

            } else {
              myState.AddToFavorites(id);
              myState.favColor = Colors.amber;
              myState.FilterContent["favorites"]=myState.favorites;

            }
          }),
        ));
  }

  Widget _isInFavorite(appState myState, String id) {
    if (myState.IsInFavorites(id)) {
      return Text("Tap to remove from favorites");
    } else {
      return Text("Add to favorites");
    }
  }

  _createBoxLegends(RockMarker rockData) {
    List<Widget> routesLegendsStripe = new List();
    Rock rock = rockData.rock.RockData;
    Map<String, int> routesCount = rock.routesStatsSimplified;

    for (var route in routesCount.keys) {
      routesLegendsStripe.add(SizedBox(
        width: 42.0,
        height: 42.0,
        child: Text(route + ":" + rock.routesStatsSimplified[route].toString()),
      ));
    }

    return routesLegendsStripe;
  }

  _createColorBoxes(RockMarker rockData) {
    List<Widget> routesBoxesStripe = new List();
    Rock rock = rockData.rock.RockData;
    Map<String, Color> routeToColorMappings = {
      "III": Colors.lightGreen,
      "IV": Colors.cyan,
      "V": Colors.orange,
      "VI": Colors.red
    };

    for (var route in rock.routesStatsSimplified.keys) {
      double height = 1.0;
      Color color = routeToColorMappings[route];
      if (rock.routesStatsSimplified[route] > 0 && rock.routesStatsSimplified[route] < 3) {
        height = 10.0;
      }
      if (rock.routesStatsSimplified[route] >= 3 && rock.routesStatsSimplified[route] < 6) {
        height = 20.0;
      }
      if (rock.routesStatsSimplified[route] >= 6 && rock.routesStatsSimplified[route] < 10) {
        height = 30.0;
      }
      if (rock.routesStatsSimplified[route] >= 10) {
        height = 42.0;
      }

      routesBoxesStripe.add(SizedBox(
          width: 42.0,
          height: height,
          child: DecoratedBox(decoration: BoxDecoration(color: color))
          ));
    }
    return routesBoxesStripe;
  }


}
