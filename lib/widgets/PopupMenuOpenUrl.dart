import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dataProvider/RockLoader.dart';
import '../Helpers/Helpers.dart';
import '../Helpers/CustomIcons.dart';

PopupMenuButton<String> dropDownOpenInfoPage(List<InfoPage> infoPage) {


  return PopupMenuButton<String>(
    color: Colors.orange,
    icon: Icon(
      Icons.info,
      color: Colors.red,
      size: 30.0,

    ),
    offset: Offset(105,200),
    itemBuilder: (context) => generatePopupMenuItem(infoPage),

    onSelected: (value) {
      launchURL(value);
    },
  );

}
List<PopupMenuItem<String>> generatePopupMenuItem(List<InfoPage> infoPage) {
  List<PopupMenuItem<String>>myList = new List();
  for (var element in infoPage) {
    myList.add(
        new PopupMenuItem<String>(
            value: element.url,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(GlobIcon.globe, color: Colors.black,),
                SizedBox(width: 10,),
                Text(element.displayName, style: TextStyle(color: Colors.black))],
            )
        ));
  }
  return myList;
}