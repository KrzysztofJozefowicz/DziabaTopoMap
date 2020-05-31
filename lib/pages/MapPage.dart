import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'zoombuttons_plugin_option.dart';
import '../widgets/drawer.dart';
import '../widgets/RockWidget.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import '../widgets/MapMarkers.dart';

import 'package:latlong/latlong.dart';
import 'dart:async';
import 'dart:developer';

class MyTestPage extends StatefulWidget {
  static const String route = 'MyTest';

  @override
  MapPage createState() {
    return MapPage();
  }
}

class MapPage extends State<MyTestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, List<Item>>> futureData;
  //myNewTopoApiData myData;


  @override
  void initState() {
    super.initState();

    futureData= fetchData();

  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  futureData= fetchData();
                });
              },
            ),
          ],

          title: Text('Topo Map')),
      drawer: buildDrawer(context, MyTestPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [

            Flexible(
              child:
              FutureBuilder<Map<String, List<Item>>> (
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && (snapshot.data["rock"].length != null) ) {
                      MapMarkers my_markers = new MapMarkers(snapshot.data["rock"], context);
                      List<Marker> markers=my_markers.markers;



                    return (
                        FlutterMap(
                        options: MapOptions(
                          plugins: [
                            ZoomButtonsPlugin(),

                          ],
                          center: LatLng(53.5, 19.09),
                          zoom: 5.0,
        //                  maxZoom: 5.0,
        //                    minZoom: 1.0,
                        ),
                        layers: [
                          TileLayerOptions(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                              tileProvider: CachedNetworkTileProvider()
                          ),
                          MarkerLayerOptions(markers: markers),
                          ZoomButtonsPluginOption(
                            minZoom: 1,
                            maxZoom: 19,
                            mini: true,
                            padding: 10,
                            alignment: Alignment.bottomRight)
                        ],

                      )
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ),
            RockWidget()

          ],
        ),
      ),
    );
  }

}

