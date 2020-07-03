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
    log("in MyApp build");
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


