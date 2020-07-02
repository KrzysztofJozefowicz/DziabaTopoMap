import 'package:flutter/material.dart';
import '../states/appState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'zoombuttons_plugin_option.dart';
import '../widgets/drawer.dart';

import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import '../widgets/MapMarkers.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

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
        child: Stack(
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                            //plugins: [ZoomButtonsPlugin(), PopupMarkerPlugin()],
                            plugins: [ZoomButtonsPlugin(), MarkerClusterPlugin()],
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
                            ZoomButtonsPluginOption(
                                minZoom: 1, maxZoom: 19, mini: true, padding: 10, alignment: Alignment.bottomRight),
                            MarkerClusterLayerOptions(
                              maxClusterRadius: 120,
                              size: Size(40, 40),
                              anchor: AnchorPos.align(AnchorAlign.center),
                              fitBoundsOptions: FitBoundsOptions(
                                padding: EdgeInsets.all(50),
                              ),
                              markers: markers,
                              polygonOptions: PolygonOptions(
                                  borderColor: Colors.blueAccent,
                                  color: Colors.black12,
                                  borderStrokeWidth: 3),
                              popupOptions: PopupOptions(
                                  popupSnap: PopupSnap.top,
                                  popupController: _popupLayerController,
                                  popupBuilder: (_, marker) => Card(
                                    color: Colors.transparent,
                                    child: GestureDetector(
                                      onTap: () => debugPrint("Popup tap!"),
                                      child:
                                          markerPopup(marker,mapController)
                                      //Text(
                                       // "Container popup for marker at ${marker.point}",
                                      //),
                                    ),
                                  )),
                              builder: (context, markers) {
                                return FloatingActionButton(
                                  child: Text(markers.length.toString()),
                                  onPressed: null,
                                );
                              },
                            ),
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
                //RockWidget()
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              //child:MapFilters(mapController),
              child:  PopupMenuButton<int>(
                icon: Icon(Icons.filter_list),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: MapFilters(mapController),
                  ),
                ],
              )
            ),

          ],
        ),
      ),
    );
  }
}
