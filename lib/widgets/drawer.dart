import 'package:flutter/material.dart';
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
          title: const Text('MyTestPage'),
          selected: currentRoute == MyTestPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MyTestPage.route);
          },
        ),


      ],
    ),
  );
}
