import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dziabak_map/pages/FavoritesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/MapPage.dart';
import './pages/InfoPage.dart';
import './pages/SettingsPage.dart';
import './states/AppState.dart';

import 'dart:developer';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<AppState>(context, listen: true);
    if (myState.isLoadedFromSharedPrefs == false) {
      _loadPreferences(myState);
      myState.isLoadedFromSharedPrefs = true;
    }

    return MaterialApp(
      title: 'Dziabak Map',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
        accentColor: Colors.orangeAccent,

        //appBarTheme:  AppBarTheme(color: Colors.),
      ),
      home: TopoMap(),
      routes: <String, WidgetBuilder>{
        TopoMap.route: (context) => TopoMap(),
        Favorites.route: (context) => Favorites(),
        InfoPage.route: (context) => InfoPage(),
        SettingsPage.route: (context) => SettingsPage(),
      },
    );
  }
}

_loadPreferences(AppState myState) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("Favorites")) {
    if (prefs.getStringList("Favorites") != null && prefs.getStringList("Favorites").length > 0) {
      List<String> savedFavorites = prefs.getStringList("Favorites");
      for (var item in savedFavorites) {
        myState.addToFavorites(item);
        myState.filterContent["favorites"] = myState.favorites;
      }
    }
  } else {
  }
}
