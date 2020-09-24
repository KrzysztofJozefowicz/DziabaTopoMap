import 'package:flutter/material.dart';
import '../pages/FavoritesPage.dart';
import '../pages/MapPage.dart';
import '../pages/InfoPage.dart';
import '../pages/SettingsPage.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Mapa'),
          selected: currentRoute == TopoMap.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, TopoMap.route);
          },
        ),
        ListTile(
          title: const Text('Ulubione'),
          selected: currentRoute == Favorites.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Favorites.route);
          },
        ),
//        ListTile(
//          title: const Text('Reklamy'),
//          //selected: currentRoute == Favorites.route,
////          onTap: () {
////            Navigator.pushReplacementNamed(context, Favorites.route);
////          },
//        ),
        ListTile(
          title: const Text('Info'),
          selected: currentRoute == InfoPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, InfoPage.route);
          },
        ),
        ListTile(
          title: const Text('Ustawienia'),
          selected: currentRoute == SettingsPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, SettingsPage.route);
          },
        ),
      ],
    ),
  );
}
