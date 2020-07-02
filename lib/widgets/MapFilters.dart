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

class MapFiltersWidget extends State<MapFilters> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController;

  MapFiltersWidget(this.mapController);

  @override
  void initState() {
    super.initState();
  }

  Widget ButtonsTogether() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ShowFavorites(),
        ShowRocksWithRouteLevel('III', "includeWithIII"),
        ShowRocksWithRouteLevel('IV', "includeWithIV"),
        ShowRocksWithRouteLevel('V', "includeWithV"),
        ShowRocksWithRouteLevel('VI', "includeWithVI"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonsTogether(),
    );
  }
}

class ShowFavorites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowFavoritesState();
}

class _ShowFavoritesState extends State<ShowFavorites> {
  _ShowFavoritesState();

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);

    Map<bool, Widget> _icons = {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Favorites only"), _icons[myState.FilterState["showOnlyFavorites"]]],
        ),
        onTap: () => setState(() {
          bool currentFavoriteState = !myState.FilterState["showOnlyFavorites"];
          myState.SetFilterState("showOnlyFavorites", currentFavoriteState);
        }),
      );
    });
    //  children:
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
  _ShowRocksWithRouteLevelState();

  Map<String, IconData> _routeIcons = {
    "III": Icons.filter_3,
    "IV": Icons.filter_4,
    "V": Icons.filter_5,
    "VI": Icons.filter_6,
  };

  Map<String, Color> _routeToColorMappings = {
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
      boxColor = _routeToColorMappings[myState.FilterContent[widget.filterName]];
    }
//_routeIcons[myState.FilterContent[widget.filterName]]
    return Consumer<appState>(builder: (context, _filterState, _) {
      return InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rocks with " + myState.FilterContent[widget.filterName]),
            Icon(_routeIcons[myState.FilterContent[widget.filterName]], color: boxColor, size: 24.0)
          ],
        ),
        onTap: () => setState(() {
          bool currentFilterRouteState = !myState.FilterState[widget.filterName];
          myState.SetFilterState(widget.filterName, currentFilterRouteState);
        }),
      );
    });
  }
}

Set<String> ApplyFilters(
    Map<String, Item> itemsToFilter, Map<String, bool> filtersState, Map<String, dynamic> filtersContent) {
  Set<String> filteredItems = new Set();

  Map<String, Rock> rocks = itemsToFilter;

  filteredItems.addAll(rocks.keys);

  if (filtersState["showOnlyFavorites"] == true) {
    log("favorites ids");
    log(filtersContent["favorites"].toString());
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


