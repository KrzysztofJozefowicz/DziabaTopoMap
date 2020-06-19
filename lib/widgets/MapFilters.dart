import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'dart:developer';

class MapFilters extends StatefulWidget {
  @override
  MapFiltersWidget createState() {
    return MapFiltersWidget();
  }
}

class MapFiltersWidget extends State<MapFilters> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          children: [
            FavoriteButton(),
            Text("has_III"),
            Text("has_IV"),
            Text("has_V"),
            Text("has_VI"),
            Text("Trad_only"),
            Text("Sport_only")
          ],
        ));
  }
}

class FavoriteButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: _icons[myState.FilterState["showOnlyFavorites"]],
            )
          ],
        ),
        onTap: () => setState(() {
          bool currentFavoriteState = !myState.FilterState["showOnlyFavorites"];
          myState.SetFilterState("showOnlyFavorites", currentFavoriteState);
        }),
      );
    });
  }
}
