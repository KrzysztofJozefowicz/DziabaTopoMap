import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:dziabak_map/main.dart';
import '../states/AppState.dart';
import 'package:provider/provider.dart';
import '../dataProvider/RockLoader.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'dart:async';
import 'dart:developer';
import '../Helpers/Helpers.dart';

class MapFilters extends StatefulWidget {
  final MapController mapController;

  MapFilters(this.mapController, {Key key}) : super(key: key);

  @override
  MapFiltersWidget createState() {
    return MapFiltersWidget(this.mapController);
    //return MapFiltersWidget();
  }
}

class MapFiltersWidget extends State<MapFilters> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MapController mapController;

  MapFiltersWidget(this.mapController);

  @override
  void initState() {
    super.initState();
  }

  Widget ButtonsTogether() {
    return Column(
      children: <Widget>[
        ShowFavorites(),
        SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text("Skały posiadające wycenę:",style: TextStyle(color: Colors.black)), ]
        ),
        SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              ShowRocksWithRouteLevel('III', "includeWithIII"),
              ShowRocksWithRouteLevel('IV', "includeWithIV"),
              ShowRocksWithRouteLevel('V', "includeWithV"),
              ShowRocksWithRouteLevel('VI', "includeWithVI"),]
        ),
        SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              ShowRocksWithRouteLevel('VI.1', "includeWithVI.1"),
              ShowRocksWithRouteLevel('VI.2', "includeWithVI.2"),
              ShowRocksWithRouteLevel('VI.3', "includeWithVI.3"),
              ShowRocksWithRouteLevel('VI.4', "includeWithVI.4"),]
        ),
        SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              ShowRocksWithRouteLevel('VI.5', "includeWithVI.5"),
              ShowRocksWithRouteLevel('VI.6', "includeWithVI.6"),
              ShowRocksWithRouteLevel('VI.7', "includeWithVI.7"),
              ShowRocksWithRouteLevel('VI.8', "includeWithVI.8"),
            ]
        ),



      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ButtonsTogether(),
    );
  }
}

class ShowFavorites extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShowFavoritesState();
}

class _ShowFavoritesState extends State<ShowFavorites> {
  _ShowFavoritesState();

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);

    Map<bool, Widget> _icons = {
      false: Icon(
        Icons.favorite,
        color: Colors.black,
        size: 24.0,
      ),
      true: Icon(
        Icons.favorite,
        color: Colors.yellow,
        size: 24.0,
      )
    };
    return Consumer<appState>(builder: (context, _filterState, _) {
      return InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tylko Ulubione", style: TextStyle(color: Colors.black)),
            _icons[myState.FilterState["showOnlyFavorites"]]
          ],
        ),
        onTap: () => setState(() {
          bool currentFavoriteState = !myState.FilterState["showOnlyFavorites"];
          myState.setFilterState("showOnlyFavorites", currentFavoriteState);
        }),
      );
    });
    //  children:
  }
}

class ShowRocksWithRouteLevel extends StatefulWidget {
  final String fieldName;
  final String filterName;

  const ShowRocksWithRouteLevel(this.fieldName, this.filterName);

  @override
  State<StatefulWidget> createState() => _ShowRocksWithRouteLevelState();
}

class _ShowRocksWithRouteLevelState extends State<ShowRocksWithRouteLevel> {
  _ShowRocksWithRouteLevelState();



  Map<String, Color> _routeToColorMappings = {
    "III": Colors.lightGreen,
    "IV": Colors.cyan,
    "V": Colors.yellow,
    "VI": Colors.pink[100],
    "VI.1": Colors.pink[200],
    "VI.2": Colors.pink[300],
    "VI.3": Colors.pink[400],
    "VI.4": Colors.pink[500],
    "VI.5": Colors.pink[600],
    "VI.6": Colors.pink[700],
    "VI.7": Colors.pink[800],
    "VI.8": Colors.pink[900],
  };

  @override
  Widget build(BuildContext context) {
    var myState = Provider.of<appState>(context, listen: true);
    Color boxColor = Colors.transparent;

    String boxName = myState.filterContent[widget.filterName];
    if (myState.FilterState[widget.filterName] == true) {

      boxColor = _routeToColorMappings[myState.filterContent[widget.filterName]];
    }

    return Consumer<appState>(builder: (context, _filterState, _) {
      return InkWell(
        child: Container(

          child:
            DrawBox(boxName,boxColor),

        ),
        onTap: () => setState(() {
          bool currentFilterRouteState = !myState.FilterState[widget.filterName];
          myState.setFilterState(widget.filterName, currentFilterRouteState);
        }),
      );
    });
  }
}

Widget DrawBox(String boxText, Color fillColor) {
  return (
      Stack(
      children: [
        Container(
          width: 30,
          height: 30,
          child: CustomPaint(painter: BoxPainter(Colors.black,PaintingStyle.stroke),),
        ),
        Container(
          width: 30,
          height: 30,
          child: CustomPaint(painter: BoxPainter(fillColor,PaintingStyle.fill),),
        ),

  Align(
  heightFactor: 1.5,

  child:
          SizedBox(
            width: 30,
            height: 30,
            child: Text(
              boxText,
              style:TextStyle(color: Colors.black, fontSize: 12),
              textAlign: TextAlign.center,
          ),
          ),
  )
//        Align(
//          heightFactor: 1.5,
//
//          child: Text(
//            boxText,
//            style:TextStyle(color: Colors.black),
//            textAlign: TextAlign.right,
//          ),
//        ),
        //Align(child:Text(boxText,style:TextStyle(color: Colors.black), textAlign: TextAlign.center,), alignment: Alignment.center, ),

      ])
      );

}

class BoxPainter extends CustomPainter {
  Color fillColor;
  PaintingStyle paintStyle ;
  BoxPainter(Color fillColor, PaintingStyle paintStyle)
  {
    this.fillColor = fillColor;
    this.paintStyle = paintStyle;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint();
    painter.style = paintStyle;
    painter.strokeWidth = 2.5;
    painter.color = fillColor;
    Radius cornerRadius = new Radius.circular(4);
    RRect box = RRect.fromLTRBR(0, 0, 30, 30, cornerRadius);
    //a rectangle
    canvas.drawRRect(box, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

