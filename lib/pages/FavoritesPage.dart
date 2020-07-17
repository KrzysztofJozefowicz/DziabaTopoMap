import 'package:flutter/material.dart';
import '../states/AppState.dart';
import '../widgets/Drawer.dart';
import 'package:provider/provider.dart';
import '../dataProvider/RockLoader.dart';
import '../widgets/MarkerPopup.dart';
import 'package:maps_launcher/maps_launcher.dart';
import '../widgets/RouteStatBoxes.dart';
import '../Helpers/Helpers.dart';

class Favorites extends StatefulWidget {
  static const String route = 'Favorites';

  @override
  FavoritesPage createState() {
    return FavoritesPage();
  }
}

class FavoritesPage extends State<Favorites> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    return Scaffold(
        backgroundColor: Colors.orangeAccent,
        key: _scaffoldKey,
        appBar: AppBar(actions: <Widget>[
          // action button
        ], title: Text('Ulubione')),
        drawer: buildDrawer(context, Favorites.route),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Flexible(child: ListView(children: _listFavorites(context, myState))),
            ])));
  }

  List<Widget> _listFavorites(BuildContext context, appState myState) {
    List<Widget> favoriteList = new List();

    for (var entry in myState.favorites) {
      Item favoriteRock = myState.getRockById(entry);
      if (favoriteRock != null) {
        favoriteList.add(InkWell(
            child: _favoriteItem(myState, favoriteRock),
            onTap: () => setState(() {
//                  if (myState.rockItem != favoriteRock){
//                  myState.rockItem = favoriteRock;}
//                  else
//                    {myState.rockItem=null;}
                })));
      }
    }
    return favoriteList;
  }

  Widget _favoriteItem(appState myState, Rock rockItem) {
    //return(Text(rockItem.title+" "+rockItem.lat+" "+rockItem.lng));
    return (Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        Text(
          rockItem.title,
          style: TextStyle(color: Colors.black),
        ),
        _routesBox(rockItem)
      ]),
      actionButtons(myState, rockItem),
      Divider(
        color: Colors.black,
        height: 5,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      )
    ]));
  }

  Widget _routesBox(Rock rockItem) {
    return Row(children: [createColorBoxes(rockItem)]);
  }

  Widget actionButtons(appState myState, Rock rockItem) {
    final double iconSize = 30.0;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      InkWell(
          child: Container(
            child: _favoriteIcons[myState.isInFavorites(rockItem.id)],
          ),
          onTap: () => setState(() {
                if (myState.isInFavorites(rockItem.id)) {
                  myState.removeFromFavorites(rockItem.id);
                } else {
                  myState.addToFavorites(rockItem.id);
                }
                myState.filterContent["favorites"] = myState.favorites;
              })),
      InkWell(
          child: Container(
              child: Icon(
            Icons.navigation,
            color: Colors.blue,
            size: iconSize,
          )),
          onTap: () => setState(() {
                MapsLauncher.launchCoordinates(double.parse(rockItem.lat), double.parse(rockItem.lng));
              })),
      InkWell(
          child: Container(child: Icon(Icons.open_in_new, color: Colors.blue, size: iconSize)),
          onTap: () => setState(() {
                launchURL(rockItem.url);
              })),
    ]);
  }

  final Map<bool, Widget> _favoriteIcons = {
    true: Icon(
      Icons.delete_forever,
      color: Colors.yellow,
      size: 30.0,
    )
  };
}
