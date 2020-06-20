import 'package:flutter/material.dart';
import '../states/appState.dart';
import '../widgets/drawer.dart';
import 'package:provider/provider.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'dart:async';
import 'dart:developer';

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
        key: _scaffoldKey,
        appBar: AppBar(actions: <Widget>[
          // action button
        ], title: Text('Favorites')),
        drawer: buildDrawer(context, Favorites.route),
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: [
              Flexible(child: ListView(children: _listFavorites(myState)))
            ])));
  }

  List<Widget> _listFavorites(appState myState) {
    List<Widget> favoriteList = new List();

    for (var entry in myState.favorites) {
      Item favoriteRock = _getItemById(myState, entry);
      if (favoriteRock != null) {
        favoriteList.add(Text(favoriteRock.title));
      }
    }
    return favoriteList;
  }

  Item _getItemById(appState myState, String id) {
    return myState.GetRockById(id);
  }
}
