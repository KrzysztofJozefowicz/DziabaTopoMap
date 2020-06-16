import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../widgets/MapMarkers.dart';
import '../widgets/drawer.dart';
import '../widgets/RockWidget.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import '../widgets/MapMarkers.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';
import 'dart:developer';

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
    bool hideMarkerPopup=false;
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: () => setState(() {myState.rockItem = _marker.rock.RockData;}),
      ),
    );
  }
  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _marker.rock.RockData.title,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}