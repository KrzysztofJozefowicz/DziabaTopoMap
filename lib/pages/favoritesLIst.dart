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

  Future<Map<String, List<Item>>> futureData;
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
      drawer: buildDrawer(context, Favorites.route),
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
                    return (
                        ListView(
                          children: _listFavorites(myState)
                        ));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
            ),



          ],
        ),
      ),
    );
  }
  List<Widget> _listFavorites(appState myState)
  {
    List<Widget> favoriteList = new List();

    for (var entry in myState.favorites)
      {

        Item favoriteRock = _getItemById(myState, entry);
        if (favoriteRock != null) {

          favoriteList.add(Text(favoriteRock.title));
        }
      }
    return favoriteList;
  }
  Item _getItemById(appState myState,String id)
  {
    return myState.GetRockById(id);
  }
}