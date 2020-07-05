import 'package:flutter/material.dart';
import '../states/appState.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import '../widgets/RockWidget.dart';
import 'dart:async';
import 'dart:developer';
import '../widgets/markerPopup.dart';

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
      Item favoriteRock = myState.GetRockById(entry);
      if (favoriteRock != null) {
        favoriteList.add(InkWell(
            child: _favoriteItem(favoriteRock),
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

  Widget _favoriteItem(Rock rockItem) {
    //return(Text(rockItem.title+" "+rockItem.lat+" "+rockItem.lng));
    return (Column(children: [
      Row(children: <Widget>[
        Text(
          rockItem.title,
          style: TextStyle(color: Colors.black),
        ),
        _routesBox(rockItem)
      ]),
      Row(children: <Widget>[_actionButtons(rockItem)])
    ]));
  }

  Widget _routesBox(Rock rockItem) {
    return Row(children: createColorBoxes(rockItem));
  }

  Widget _actionButtons(Rock rockItem) {
    return (Row(
      children: [
        _showOnMap(rockItem),
        _openInBrowser(rockItem),
        _navigateToRock(rockItem),
        _removeFromFavorites(rockItem)
      ],
    ));
  }

  Widget _showOnMap(Rock rockItem) {
    return (Icon(Icons.title));
  }

  Widget _openInBrowser(Rock rockItem) {
    return (Icon(Icons.title));
  }

  Widget _navigateToRock(Rock rockItem) {
    return (Icon(Icons.title));
  }

  Widget _removeFromFavorites(Rock rockItem) {
    return (Icon(Icons.title));
  }
}
