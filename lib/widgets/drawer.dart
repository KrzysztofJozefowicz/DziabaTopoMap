import 'package:flutter/material.dart';
import '../pages/favoritesLIst.dart';
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
          selected: currentRoute == MyTestPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MyTestPage.route);
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
