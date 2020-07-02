import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import '../widgets/MapMarkers.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:latlong/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
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
        color: Colors.greenAccent,
        child: InkWell(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: 50, maxWidth: 200),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _rockName(myState),
                      _createBoxes(),
                      //_createLegends(),
                      _buildIconBar(_marker.rock.RockData, _mapController)
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
          )),
      onTap: () => setState(() {
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
            children: _createColorBoxes(_marker)));
  }

  List<Widget> _createColorBoxes(RockMarker rockData) {
    List<Widget> routesBoxesStripe = new List();
    Rock rock = rockData.rock.RockData;
    Map<String, Color> routeToColorMappings = {
      "III": Colors.lightGreen,
      "IV": Colors.cyan,
      "V": Colors.orange,
      "VI": Colors.red
    };

    for (var route in rock.routesStatsSimplified.keys) {
      double boxHeight = 1.0;
      Color boxColor = routeToColorMappings[route];
      if (rock.routesStatsSimplified[route] > 0 && rock.routesStatsSimplified[route] < 3) {
        boxHeight = 10.0;
      }
      if (rock.routesStatsSimplified[route] >= 3 && rock.routesStatsSimplified[route] < 6) {
        boxHeight = 20.0;
      }
      if (rock.routesStatsSimplified[route] >= 6 && rock.routesStatsSimplified[route] < 10) {
        boxHeight = 30.0;
      }
      if (rock.routesStatsSimplified[route] >= 10) {
        boxHeight = 42.0;
      }
      routesBoxesStripe.add(Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(width: 42.0, height: boxHeight, child: DecoratedBox(decoration: BoxDecoration(color: boxColor))),
          SizedBox(
              width: 42.0,
              height: 42.0,
              child: Center(child: Text(route + ":" + rock.routesStatsSimplified[route].toString()))),
        ],
      ));
    }
    return routesBoxesStripe;
  }
}

class _buildIconBar extends StatefulWidget {
  final Rock _rockItem;
  final MapController _mapController;

  _buildIconBar(this._rockItem, this._mapController, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      //_FavoriteButtonState();
      _buildIconBarState(this._rockItem, this._mapController);
}

class _buildIconBarState extends State<_buildIconBar> {
  final Rock _rockItem;
  final MapController _mapController;
  final double iconSize=30.0;


  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    return Row(

        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
      InkWell(
          child: Container(
            child: _favoriteIcons[myState.IsInFavorites(_rockItem.id)],
          ),
          onTap: () => setState(() {
                if (myState.IsInFavorites(_rockItem.id)) {
                  myState.RemoveFromFavorites(_rockItem.id);
                } else {
                  myState.AddToFavorites(_rockItem.id);
                }
                myState.FilterContent["favorites"] = myState.favorites;
              })),
      InkWell(
          child: Container(
              child: Icon(Icons.navigation, color: Colors.blue, size: iconSize,)),
          onTap: () => setState(() {
                MapsLauncher.launchCoordinates(
                double.parse(_rockItem.lat), double.parse(_rockItem.lng ));
              })),
      InkWell(
          child: Container(
              child: Icon(Icons.open_in_new, color: Colors.blue, size: iconSize)),
          onTap: () => setState(() {
            _launchURL(context, _rockItem.url);
          })),

      InkWell(
          child: Container(
            child: Icon(Icons.zoom_out_map, color: Colors.red, size: iconSize),
          ),
          onTap: () => setState(() {
                // TODO: move previous map possition and zoom to state
                LatLng latlng = LatLng(double.parse(_rockItem.lat), double.parse(_rockItem.lng));
                double zoom = 15.0; //the zoom you want
                _mapController.move(latlng, zoom);
              }))
    ]);
  }

  _buildIconBarState(this._rockItem, this._mapController);

  final Map<bool, Widget> _favoriteIcons = {
    false: Icon(
      Icons.favorite,
      color: Colors.grey,
      size: 30.0,
    ),
    true: Icon(
      Icons.favorite,
      color: Colors.orange,
      size: 30.0,
    )
  };
}
_launchURL(BuildContext context,String url) async {
  const baseUrl = "http://topo.portalgorski.pl/";
  String urlToLoad = baseUrl+url;

  if (await canLaunch(urlToLoad)) {
    await launch(urlToLoad);
  } else {
    throw 'Could not launch $urlToLoad';
  }
}