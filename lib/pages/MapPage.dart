import 'package:flutter/material.dart';
import '../states/AppState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import '../widgets/Drawer.dart';

import 'package:provider/provider.dart';
import '../dataProvider/RockLoader.dart';
import '../widgets/MapMarkers.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import '../widgets/MapControlButtons.dart';
import '../widgets/MarkerPopup.dart';
import '../widgets/MapFilters.dart';
import 'package:user_location/user_location.dart';
import '../Helpers/Helpers.dart';


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
  StreamController<LatLng> markerlocationStream = StreamController();
  UserLocationOptions userLocationOptions;
  MapController mapController = new MapController();

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    MapController mapController = new MapController();

  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('DziabaTopo')),
      drawer: buildDrawer(context, TopoMap.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(child: Consumer<appState>(builder: (context, _filterState, _) {
                  return FutureBuilder<Map<String, Map<String, Item>>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && (snapshot.data["rock"].length != null)) {
                        myState.populateRocks(snapshot.data["rock"]);
                        myState.RocksIdToDisplay =
                            ApplyFilters(myState.rocks, myState.FilterState, myState.filterContent);
                        MapMarkers myMarkers = new MapMarkers(myState.getRocksItemsToDisplay());
                        List<Marker> markers = myMarkers.markers;
                        List<Marker> markersEmpty = new List();
                        userLocationOptions = UserLocationOptions(
                          context: context,
                          mapController: mapController,
                          markers: markersEmpty,
                          onLocationUpdate: (LatLng pos) => {myState.currentUserLocation = pos},
                          updateMapLocationOnPositionChange: false,
                          showMoveToCurrentLocationFloatingActionButton: false,
                          zoomToCurrentLocationOnLoad: false,
                        );


                        return (Stack(children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              plugins: [MarkerClusterPlugin(), UserLocationPlugin()],
                              interactive: true,
                              onTap: (_) => setState(() {
                                _popupLayerController.hidePopup();
                                myState.clearRockItem();
                              }),
                              center: LatLng(53.5, 19.09),
                              zoom: 5.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: ['a', 'b', 'c'],
                                  tileProvider: CachedNetworkTileProvider()),
                              MarkerClusterLayerOptions(
                                maxClusterRadius: 120,
                                size: Size(40, 40),
                                anchor: AnchorPos.align(AnchorAlign.center),
                                fitBoundsOptions: FitBoundsOptions(
                                  padding: EdgeInsets.all(50),
                                ),
                                markers: markers,
                                polygonOptions: PolygonOptions(
                                    borderColor: Colors.blueAccent, color: Colors.black12, borderStrokeWidth: 3),
                                popupOptions: PopupOptions(
                                    popupSnap: PopupSnap.top,
                                    popupController: _popupLayerController,
                                    popupBuilder: (_, marker) => Card(
                                          color: Colors.transparent,
                                          child: GestureDetector(
                                              onTap: () => debugPrint("Popup tap!"),
                                              child: markerPopup(marker, mapController)),
                                        )),
                                builder: (context, markers) {
                                  return FloatingActionButton(
                                    child: Text(markers.length.toString()),
                                    onPressed: null,
                                    heroTag: null,
                                  );
                                },
                              ),
                              MarkerLayerOptions(markers: markersEmpty),
                              userLocationOptions,
                            ],
                          ),
                          MapControlButtons(mapController, userLocationOptions)
                        ]));
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
                child: PopupMenuButton<int>(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(
                    Icons.filter_list,
                    color: Theme.of(context).primaryColor,
                    size: 40.0,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: MapFilters(mapController),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
