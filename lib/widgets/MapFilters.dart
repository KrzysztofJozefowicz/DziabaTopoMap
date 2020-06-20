import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../states/appState.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'dart:developer';

class MapFilters extends StatefulWidget {
  final MapController mapController;

  MapFilters(this.mapController, {Key key}) : super(key: key);

  @override
  MapFiltersWidget createState() {
    return MapFiltersWidget(this.mapController);
  }
}

class MapFiltersWidget extends State<MapFilters> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController;

  MapFiltersWidget(this.mapController);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    return Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FavoriteButton(mapController),
            ShowRocksWithRouteLevel('III', "includeWithIII"),
            ShowRocksWithRouteLevel('IV', "includeWithIV"),
            ShowRocksWithRouteLevel('V', "includeWithV"),
            ShowRocksWithRouteLevel('VI', "includeWithVI"),
            //Text("Trad_only"),
            // Text("Sport_only")
          ],
        ));
  }
}

class FavoriteButton extends StatefulWidget {
  final MapController mapController;

  FavoriteButton(this.mapController, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _FavoriteButtonState(this.mapController);
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final MapController mapController;

  _FavoriteButtonState(this.mapController);

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    final Map<bool, Widget> _icons = {
      false: Icon(
        Icons.favorite,
        color: Colors.grey,
        size: 24.0,
      ),
      true: Icon(
        Icons.favorite,
        color: Colors.orange,
        size: 24.0,
      )
    };
    return Consumer<appState>(builder: (context, _filterState, _) {
      return InkWell(
        child: _icons[myState.FilterState["showOnlyFavorites"]],
        onTap: () => setState(() {
          bool currentFavoriteState = !myState.FilterState["showOnlyFavorites"];
          myState.SetFilterState("showOnlyFavorites", currentFavoriteState);
          if (currentFavoriteState == true) {
            List<LatLng> mapBounds = new List();
            for (var element in myState.favorites) {
              Item rock = myState.GetRockById(element);
              mapBounds.add(
                LatLng(double.parse(rock.lat), double.parse(rock.lng)),
              );
            }
            var fitOptions =
                new FitBoundsOptions(padding: EdgeInsets.all(75.0));
            mapController.fitBounds(LatLngBounds.fromPoints(mapBounds),
                options: fitOptions);
          }

        }),
      );
    });
  }
}

class ShowRocksWithRouteLevel extends StatefulWidget {
  final String fieldName;
  final String filterName;

  const ShowRocksWithRouteLevel(this.fieldName, this.filterName);

  @override
  State<StatefulWidget> createState() => _ShowRocksWithRouteLevelState();
}

class _ShowRocksWithRouteLevelState extends State<ShowRocksWithRouteLevel> {
  Map<String, Color> routeToColorMappings = {
    "III": Colors.lightGreen,
    "IV": Colors.cyan,
    "V": Colors.orange,
    "VI": Colors.red
  };

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    Color boxColor = Colors.grey;
    if (myState.FilterState[widget.filterName] == true) {
      boxColor = routeToColorMappings[myState.FilterContent[widget.filterName]];
    }

    return Consumer<appState>(builder: (context, _filterState, _) {
      return InkWell(
          child: Stack(
            children: <Widget>[
              SizedBox(
                  width: 42.0,
                  height: 42.0,
                  child:
                      DecoratedBox(decoration: BoxDecoration(color: boxColor))
                  //child: Text(route+":"+routesCount[route].toString()),
                  ),
              SizedBox(
                  width: 42.0,
                  height: 42.0,
                  child: Center(child: Text(widget.fieldName))),
            ],
          ),
          onTap: () => setState(() {
                bool currentFilterRouteState =
                    !myState.FilterState[widget.filterName];

                myState.SetFilterState(
                    widget.filterName, currentFilterRouteState);
              }));
    });
    ;
  }
}
