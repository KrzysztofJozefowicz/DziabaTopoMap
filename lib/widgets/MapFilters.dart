import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:topo_map/main.dart';
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
    //return MapFiltersWidget();
  }
}

class MapFiltersWidget extends State<MapFilters> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController;

  //MapFiltersWidget();
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
            //FavoriteButton(mapController),
            FavoriteButton(mapController),
            ShowRocksWithRouteLevel('III', "includeWithIII",mapController),
            ShowRocksWithRouteLevel('IV', "includeWithIV",mapController),
            ShowRocksWithRouteLevel('V', "includeWithV",mapController),
            ShowRocksWithRouteLevel('VI', "includeWithVI",mapController),
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
      //_FavoriteButtonState();
      _FavoriteButtonState(this.mapController);
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final MapController mapController;

  //_FavoriteButtonState();
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
          moveMApToFitFilteredMarkers(myState,mapController);

        }),
      );
    });
  }
}

class ShowRocksWithRouteLevel extends StatefulWidget {
  final String fieldName;
  final String filterName;
  final MapController mapController;

  //ShowRocksWithRouteLevel(this.mapController, {Key key}) : super(key: key);

  const ShowRocksWithRouteLevel(this.fieldName, this.filterName, this.mapController);

  @override
  State<StatefulWidget> createState() => _ShowRocksWithRouteLevelState(mapController);
}

class _ShowRocksWithRouteLevelState extends State<ShowRocksWithRouteLevel> {
  final MapController mapController;
  _ShowRocksWithRouteLevelState(this.mapController);

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
              SizedBox(width: 42.0, height: 42.0, child: DecoratedBox(decoration: BoxDecoration(color: boxColor))
                  //child: Text(route+":"+routesCount[route].toString()),
                  ),
              SizedBox(width: 42.0, height: 42.0, child: Center(child: Text(widget.fieldName))),
            ],
          ),
          onTap: () => setState(() {
                bool currentFilterRouteState = !myState.FilterState[widget.filterName];
                myState.SetFilterState(widget.filterName, currentFilterRouteState);
                moveMApToFitFilteredMarkers(myState,mapController);
              }));
    });
    ;
  }
}

Set<String> ApplyFilters(
    Map<String, Item> itemsToFilter, Map<String, bool> filtersState, Map<String, dynamic> filtersContent) {
  Set<String> filteredItems = new Set();

  Map<String, Rock> rocks = itemsToFilter;

  filteredItems.addAll(rocks.keys);

  if (filtersState["showOnlyFavorites"] == true) {
    for (var rockId in rocks.keys) {
      if (filtersContent["favorites"].contains(rockId) != true) {
        filteredItems.remove(rockId);
      }
    }
  }
  List<String> routeFilters = ["includeWithIII", "includeWithIV", "includeWithV", "includeWithVI"];
  for (var filter in routeFilters) {
    if (filtersState[filter] == true) {
      String currentRouteLevel = filtersContent[filter];
      for (var rock in rocks.values) {
        if (rock.routesStatsSimplified[currentRouteLevel] == 0) {
          filteredItems.remove(rock.id);
        }
      }
    }
  }
  return filteredItems;
}

MapController fitMarkersToView(Iterable ItemsToDisplay, MapController mapController) {
  if (mapController != null) {
    var fitOptions = new FitBoundsOptions(padding: EdgeInsets.all(75.0));
    var mapBounds = SetMapBounds(ItemsToDisplay);
    mapController.fitBounds(LatLngBounds.fromPoints(mapBounds), options: fitOptions);
    return mapController;
  }
}

List<LatLng> SetMapBounds(Iterable ListOfItems) {
  List<LatLng> mapBounds = new List();
  for (var element in ListOfItems) {
    Rock rock = element;
    mapBounds.add(
      LatLng(double.parse(rock.lat), double.parse(rock.lng)),
    );
  }
  return mapBounds;
}

moveMApToFitFilteredMarkers(appState myState, MapController mapController)
{
  myState.RocksIdToDisplay = ApplyFilters(myState.rocks, myState.FilterState, myState.FilterContent);
  var fitOptions = new FitBoundsOptions(padding: EdgeInsets.all(75.0));
  var mapBounds = SetMapBounds(myState.GetRocksItemsToDisplay());
  mapController.fitBounds(LatLngBounds.fromPoints(mapBounds), options: fitOptions);

}