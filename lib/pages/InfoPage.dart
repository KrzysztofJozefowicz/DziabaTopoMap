import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Drawer.dart';
import '../widgets/GitHubIcon.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  static const String route = 'InfoPage';

  @override
  InfoPageState createState() {
    return InfoPageState();
  }
}

class InfoPageState extends State<InfoPage> {
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
        ], title: Text('Info')),
        drawer: buildDrawer(context, InfoPage.route),
        body:
        Padding(
            padding: EdgeInsets.all(8.0),
            child:InfoText())
          );
  }
  Widget InfoText()
  {
    TextStyle textStyle = TextStyle(color: Colors.black);
    return(
        Column(
            children: <Widget> [
              Wrap(children: <Widget> [Text(
                "Dziaba Topo Map\n\nMapa topo miejsc wspinaczkowych w Polsce.\n\nNa podstawie danych z topo.portalgorski.pl \n",style: textStyle,softWrap: true,
              ),
                Text(
                  "Wszelkie pytania i sugestie zgłoś na stronie projektu na GitHubie.\n\n\n",style: textStyle, softWrap: true,
                )

              ]),
              InkWell(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(GitHubIcons.github,color: Colors.black, size: 30,),
                      Text("Projekt na GitHubie ", style: textStyle)]
                ),
              onTap: () => setState(() {
                launchURL("https://github.com/KrzysztofJozefowicz/DziabakMap");})


              )
            ]));
  }
  launchURL(String url) async {
    String urlToLoad = url;

    if (await canLaunch(urlToLoad)) {
      await launch(urlToLoad);
    } else {
      throw 'Could not launch $urlToLoad';
    }
  }
}
