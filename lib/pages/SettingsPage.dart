import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Drawer.dart';
import '../dataProvider/JsonAssetHandler.dart';
import '../states/AppState.dart';
import 'package:provider/provider.dart';
import 'package:download_assets/download_assets.dart';

class SettingsPage extends StatefulWidget {
  static const String route = 'SettingsPage';

  @override
  SettingsPageState createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldcontroller ;
  @override
  void initState() {
    super.initState();
    _textFieldcontroller  = new TextEditingController(text: 'https://github.com/KrzysztofJozefowicz/DziabaTopoMap/blob/master/assets/rockApiData.json');
    DownloadAssetsController.init();
  }

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<AppState>(context, listen: true);
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
            child:settingsContent(myState))
    );
  }
  Widget settingsContent(AppState myState)
  {
    TextStyle textStyle = TextStyle(color: Colors.black);
    return(
        Column(
            children: <Widget> [
              Text(
                "Ustawienia \n",style: textStyle,softWrap: true,
              ),
              Text("file path: "),
              TextField(controller: _textFieldcontroller ,),
              RaisedButton(
                onPressed: () {
                  // You can also use the controller to manipuate what is shown in the
                  // text field. For example, the clear() method removes all the text
                  // from the text field.
                  myState.jsonAsset.getNewJsonAndActivateIt(_textFieldcontroller.text);
                },
                child: new Text('download'),
              ),
              Text("file in use"+myState.jsonAsset.currentJsonAssetPath),
              Text("restore to default path"),
              ]));


  }
}
