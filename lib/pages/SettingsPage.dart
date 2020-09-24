import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Drawer.dart';

class SettingsPage extends StatefulWidget {
  static const String route = 'SettingsPage';

  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orangeAccent,
        key: _scaffoldKey,
        appBar: AppBar(actions: <Widget>[
          // action button
        ], title: Text('Ustawienia')),
        drawer: buildDrawer(context, SettingsPage.route),
        body:
        Padding(
            padding: EdgeInsets.all(8.0),
            child:infoText())
    );
  }
  Widget infoText()
  {
    TextStyle textStyle = TextStyle(color: Colors.black);
    return(
        Column(
            children: <Widget> [
              Text(
                "Ustawienia \n",style: textStyle,softWrap: true,
              )
              ]));


  }
}
