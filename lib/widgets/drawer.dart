import 'package:flutter/material.dart';
import '../pages/FavoritesPage.dart';
import '../pages/MapPage.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Topo'),
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
        ListTile(
          title: const Text('Reklamy'),
          //selected: currentRoute == Favorites.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, Favorites.route);
//          },
        ),
        ListTile(
          title: const Text('Info'),
          //selected: currentRoute == Favorites.route,
//          onTap: () {
//            Navigator.pushReplacementNamed(context, Favorites.route);
          //},
        ),
      ],
    ),
  );
}
