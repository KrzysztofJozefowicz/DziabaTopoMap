import 'package:flutter/material.dart';
import '../pages/FavoritesPage.dart';
import '../pages/MapPage.dart';


Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Flutter Map Examples'),
          ),
        ),
        ListTile(
          title: const Text('Map'),
          selected: currentRoute == TopoMap.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, TopoMap.route);
          },
        ),
        ListTile(
          title: const Text('Favorites'),
          selected: currentRoute == Favorites.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, Favorites.route);
          },
        ),

      ],
    ),
  );
}
