import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topo_map/pages/FavoritesPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './pages/MapPage.dart';
import './states/appState.dart';
import 'dart:developer';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => appState(),
      child: MyApp(),
    ),
  );

//  runApp(
//    MultiProvider(
//      providers: [ChangeNotifierProvider(builder: (context) => appState())],
//      child: MyApp(),
//    ),
//  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    if (myState.isLoadedFromSharedPrefs == false)
      {
        log("loading preferences from shared prefs");
        _loadPreferences(myState);
        myState.isLoadedFromSharedPrefs = true;
        log("favorites state");
        log(myState.favorites.toString());
      }
    else
      {
        log("preferences already loaded");
      }

    log("main");

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
      },
    );
  }
}
_loadPreferences(appState myState) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey("Favorites"))
    {
      log("loading Favorites from shared prefs");
      if (prefs.getStringList("Favorites") != null && prefs.getStringList("Favorites").length>0)
        {
          List<String> savedFavorites=prefs.getStringList("Favorites");
          for (var item in savedFavorites)
            {
              myState.AddToFavorites(item);
              myState.FilterContent["favorites"] = myState.favorites;
            }
        }
    }
  else
    {
      log("no Favorites key found in prefs");
    }
}
