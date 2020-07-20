import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../states/AppState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/MapMarkers.dart';
import 'package:provider/provider.dart';
import '../widgets/RouteStatBoxes.dart';
import '../widgets/RouteIconBar.dart';
import 'dart:developer';

class markerPopup extends StatefulWidget {
  final Marker marker;
  final MapController mapController;

  markerPopup(this.marker, this.mapController, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _markerPopupState(this.marker, this.mapController);
}

class _markerPopupState extends State<markerPopup> {
  final RockMarker _marker;
  final MapController _mapController;

  _markerPopupState(this._marker, this._mapController);

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    return Consumer<appState>(builder: (context, favorites, _) {
      return Card(
        color: Colors.orangeAccent,
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: 50, maxWidth: 250),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _rockName(myState),
                      _createBoxes(),
                      //_createLegends(),
                      buildIconBar(_marker.rock.RockData, _mapController)
                    ]),
              ),
              //_cardDescription(context),
            ],
          ),

        ),
      );
    });
  }

  Widget _rockName(appState myState) {
    return InkWell(
      child: Text(_marker.rock.RockData.title,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: Colors.black
          )),
      onTap: () =>
          setState(() {
            myState.rockItem = _marker.rock.RockData;
          }),
    );
  }

  Widget _createBoxes() {
    return Container(
        color: Colors.transparent,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [createColorBoxes(_marker)]));
  }
}




