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
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'dart:developer';
import '../widgets/markerPopup.dart';
import '../widgets/MapFilters.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert' show json;

class TopoMap extends StatefulWidget {
  static const String route = 'TopoMap';

  @override
  TopoMapPage createState() {
    return TopoMapPage();
  }
}

class TopoMapPage extends State<TopoMap> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PopupController _popupLayerController = PopupController();
  Future<Map<String, Map<String, Item>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    MapController mapController = new MapController();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              futureData = fetchData();
            });
          },
        ),
      ], title: Text('Topo Map')),
      drawer: buildDrawer(context, TopoMap.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            MapFilters(mapController),
            //MapFilters(),

            Flexible(child: Consumer<appState>(builder: (context, _filterState, _) {
              return FutureBuilder<Map<String, Map<String, Item>>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && (snapshot.data["rock"].length != null)) {
                    myState.PopulateRocks(snapshot.data["rock"]);
                    myState.RocksIdToDisplay = ApplyFilters(myState.rocks, myState.FilterState, myState.FilterContent);
                    MapMarkers my_markers = new MapMarkers(myState.GetRocksItemsToDisplay());
                    List<Marker> markers = my_markers.markers;
                    return (FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        plugins: [ZoomButtonsPlugin(), PopupMarkerPlugin()],
                        interactive: true,
                        onTap: (_) => setState(() {
                          _popupLayerController.hidePopup();
                          myState.ClearRockItem();
                        }),
                        center: LatLng(53.5, 19.09),
                        zoom: 5.0,
                        //                  maxZoom: 5.0,
                        //                    minZoom: 1.0,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: ['a', 'b', 'c'],
                            tileProvider: CachedNetworkTileProvider()),
                        MarkerLayerOptions(markers: markers),
                        PopupMarkerLayerOptions(
                          markers: markers,
                          popupController: _popupLayerController,
                          popupBuilder: (_, Marker marker) {
                            if (marker is RockMarker) {
                              return markerPopup(marker, mapController);
                            }
                            return Card(child: const Text('NotImplemented: Not a RockMarker'));
                          },
                        ),
                        ZoomButtonsPluginOption(
                            minZoom: 1, maxZoom: 19, mini: true, padding: 10, alignment: Alignment.bottomRight)
                      ],
                    ));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              );
            })),
            RockWidget()
          ],
        ),
      ),
    );
  }
}
