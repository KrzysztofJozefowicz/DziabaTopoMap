import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../states/AppState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/MapMarkers.dart';
import 'package:provider/provider.dart';
import '../widgets/RouteStatBoxes.dart';
import '../widgets/RouteIconBar.dart';
import 'dart:developer';

class MarkerPopup extends StatefulWidget {
  final Marker marker;
  final MapController mapController;

  MarkerPopup(this.marker, this.mapController, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MarkerPopupState(this.marker, this.mapController);
}

class _MarkerPopupState extends State<MarkerPopup> {
  final RockMarker _marker;
  final MapController _mapController;

  _MarkerPopupState(this._marker, this._mapController);

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<AppState>(context, listen: true);
    return Consumer<AppState>(builder: (context, favorites, _) {
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
                      BuildIconBar(_marker.rock.rockData, _mapController)
                    ]),
              ),
              //_cardDescription(context),
            ],
          ),

        ),
      );
    });
  }

  Widget _rockName(AppState myState) {
    return InkWell(
      child: Text(_marker.rock.rockData.title,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
              color: Colors.black
          )),
      onTap: () =>
          setState(() {
            myState.rockItem = _marker.rock.rockData;
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




