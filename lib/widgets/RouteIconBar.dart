import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataProvider/RockLoader.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../states/AppState.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../widgets/PopupMenuOpenUrl.dart';
import 'package:latlong/latlong.dart';
import 'dart:developer';

class BuildIconBar extends StatefulWidget {
  final Rock _rockItem;
  final MapController _mapController;

  BuildIconBar(this._rockItem, this._mapController, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      //_FavoriteButtonState();
      BuildIconBarState(this._rockItem, this._mapController);
}

class BuildIconBarState extends State<BuildIconBar> {
  final Rock _rockItem;
  final MapController _mapController;
  final double iconSize = 30.0;

  BuildIconBarState(this._rockItem, this._mapController);

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<AppState>(context, listen: true);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      InkWell(
          child: Container(
            child: _favoriteIcons[myState.isInFavorites(_rockItem.id)],
          ),
          onTap: () => setState(() {
                if (myState.isInFavorites(_rockItem.id)) {
                  myState.removeFromFavorites(_rockItem.id);
                } else {
                  myState.addToFavorites(_rockItem.id);
                }
                myState.filterContent["favorites"] = myState.favorites;
              })),
      InkWell(
          child: Container(
              child: Icon(
            Icons.navigation,
            color: Colors.red,
            size: iconSize,
          )),
          onTap: () => setState(() {
                MapsLauncher.launchCoordinates(double.parse(_rockItem.lat), double.parse(_rockItem.lng));
              })),
      InkWell(
          child: Container(
              child: dropDownOpenInfoPage(_rockItem.infoPage)
              )),
      InkWell(
          child: Container(
            child: Icon(Icons.zoom_in, color: Colors.red, size: iconSize),
          ),
          onTap: () => setState(() {
                // TODO: move previous map possition and zoom to state
                LatLng latlng = LatLng(double.parse(_rockItem.lat), double.parse(_rockItem.lng));
                double zoom = 15.0; //the zoom you want
                _mapController.move(latlng, zoom);
              }))
    ]);
  }


  }
  final Map<bool, Widget> _favoriteIcons = {
    false: Icon(
      Icons.favorite,
      color: Colors.black,
      size: 30.0,
    ),
    true: Icon(
      Icons.favorite,
      color: Colors.yellow,
      size: 30.0,
    )
  };


