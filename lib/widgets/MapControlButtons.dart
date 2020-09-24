import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:user_location/user_location.dart';
import 'dart:async';
import 'package:latlong/latlong.dart';
import 'dart:developer';
import '../states/AppState.dart';
import 'package:provider/provider.dart';

class MapControlButtons extends StatefulWidget {
  final MapController mapController;
  final UserLocationOptions userLocationOptions;

  MapControlButtons(this.mapController, this.userLocationOptions,{Key key}) : super(key: key);

  @override
  MapControlButtonsWidget createState() {
    return MapControlButtonsWidget(this.mapController, this.userLocationOptions);

  }
}

class MapControlButtonsWidget extends State<MapControlButtons> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController;
  final UserLocationOptions userLocationOptions;

  MapControlButtonsWidget(this.mapController, this.userLocationOptions);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<AppState>(context, listen: true);
    return Positioned(
        bottom: 0,
        right: 0,
        child:Column(
      children: [
        userLocationFAB(userLocationOptions,mapController,myState),
        zoomFAB(mapController,"zoom_in"),
        zoomFAB(mapController,"zoom_out"),
      ],
    ));
  }
  Widget userLocationFAB(UserLocationOptions userLocationOptions, MapController mapController, AppState myState)
  {

    log(userLocationOptions.updateMapLocationOnPositionChange.toString());
    return(
    FloatingActionButton(
      onPressed: () {
       mapController.move(myState.currentUserLocation, mapController.zoom);
      },
      child: Icon(
        Icons.my_location,
        color: Colors.black,
        size: 24.0,
      ),

      heroTag: null,
      )
    );
  }
  Widget zoomFAB(MapController mapController,String action)
  {
    double zoomStep = (action == "zoom_in")? 1 : -1 ;
    Map<String, Widget> _icons = {
      "zoom_in": Icon(
        Icons.zoom_in,
        color: Colors.black,
        size: 24.0,
      ),
      "zoom_out": Icon(
        Icons.zoom_out,
        color: Colors.black,
        size: 24.0,
      )
    };
    return(
        FloatingActionButton(
          onPressed: () {
            mapController.move(mapController.center, mapController.zoom + zoomStep);
          },
          child: _icons[action],
          foregroundColor: Colors.red,
          heroTag: null,
        )
    );
  }


}