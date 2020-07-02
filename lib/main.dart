import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:topo_map/pages/FavoritesPage.dart';

import './pages/MapPage.dart';
import './states/appState.dart';


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
    return MaterialApp(
      title: 'Dziabak Map',
      theme: ThemeData(
        primarySwatch: mapBoxBlue,
      ),
      home: TopoMap(),
      routes: <String, WidgetBuilder>{
        TopoMap.route: (context) => TopoMap(),
        Favorites.route: (context) => Favorites(),
      },
    );
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = MaterialColor(
  _bluePrimary,
  <int, Color>{
    50: Color(0xFFE7EBFE),
    100: Color(0xFFC4CEFE),
    200: Color(0xFF9CADFD),
    300: Color(0xFF748CFC),
    400: Color(0xFF5773FB),
    500: Color(_bluePrimary),
    600: Color(0xFF3352F9),
    700: Color(0xFF2C48F9),
    800: Color(0xFF243FF8),
    900: Color(0xFF172EF6),
  },
);
