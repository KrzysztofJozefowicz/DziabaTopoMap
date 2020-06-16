import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'dart:developer';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

//class myNewTopoApiData {
//  List<Item> rocks = new List();
//  List<Item> areas = new List();
//  List<Item> sectors = new List();
//  List<Item> area_simple = new List();
//  myNewTopoApiData()
//  {
//    myNewTopoApi apiResponse = new myNewTopoApi();
//    this.populateWithData(apiResponse);
//  }
//
//
//  Future<void> populateWithData(myNewTopoApi apiResponse) async
//  {
//    apiResponse.addData(apiResponse.sudetyUrl).then((value) {
//        this.rocks = new List();
//        for (var element in  apiResponse.rocks)
//        {
//          this.rocks.add(element);
//        }
//      });
//  }
//}

Future<Map<String, List<Item>>> fetchData() async
{
  String url_sudety = 'http://topo.portalgorski.pl/topo/json/get/id/634';
  String url_beskidy = 'http://topo.portalgorski.pl/topo/json/get/id/737';
  String url_jura = 'http://topo.portalgorski.pl/topo/json/get/id/34';
  String url_podkarpacie = 'http://topo.portalgorski.pl/topo/json/get/id/131';
  String url_swietokrzyskie = 'http://topo.portalgorski.pl/topo/json/get/id/540';
  String url_podhale = 'http://topo.portalgorski.pl/topo/json/get/id/930';



  //return await callTopoApi(url_sudety);
  return await  loadAsset();
}

Future<Map<String, List<Item>>> loadAsset() async {
  final response =  await rootBundle.loadString('assets/rockApiData.json');
  Map<String, List<Item>> out;
  out=groupItemsByType(json.decode(response));
  return out;
}

Future<Map<String, List<Item>>> callTopoApi(String url) async
{
  final response =  await http.get(url);
  if (response.statusCode == 200) {
    Map<String, List<Item>> out;
    out=groupItemsByType(json.decode(response.body));
    return out;}
  else {
    throw Exception('Failed to load API from PortalGorski');
  }

}

Map<String, List<Item>> groupItemsByType(Map<String, dynamic> json) {
  Map<String, List<Item>> sortedItems = {
    "area": List<Item>(),
    "area_simple": List<Item>(),
    "rock": List<Item>(),
    "sector": List<Item>()
  };


   for (Map<String,dynamic> item in json.values)
   {
    Item i = Item.getItemFromJson(item);
    if (i.type == "area" ) {
      sortedItems["area"].add(i);
    }
    if (i.type == "rock") {
      sortedItems["rock"].add(i);
    }
    if (i.type == "sector") {
      sortedItems["sector"].add(i);
    }
    if (i.type == "area_simple") {
      sortedItems["area_simple"].add(i);
    }
  }
  return sortedItems;
}



abstract class Item {
  String id;
  String lat;
  String lng;
  String title;
  String description;
  String type;
  String url;
  String img;
  Item();
  factory  Item.getItemFromJson(Map<String, dynamic> json)
  {
    if (json.containsKey("type") && json["type"]=='rock')
      {
        return Rock.fromJson(json);
      }
    if (json.containsKey("type") && json["type"]=='sector')
    {
      return Sector.fromJson(json);
    }
    if (json.containsKey("type") && json["type"]=='area')
    {
      return Area.fromJson(json);
    }
    if (json.containsKey("type") == false)
      {
        return AreaSimple.fromJson(json);
      }

  }
}

class Area extends Item {
  final String id;
  final String lat;
  final String lng;
  final String title;
  final String description;
  final String type;
  final String url;
  final String img;
  final String gpsPointsList;
  Area(this.id, this.lat, this.lng, this.title,this.description,this.type,this.url,this.img,this.gpsPointsList);
  Area.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        lat = json["lat"],
        lng = json['lng'],
        title = json['title'],
        description = json['description'],
        type = json['type'],
        url = json['url'],
        img = json['img'],
        gpsPointsList = json["gpsPointsList"];
}

class Sector extends Item {
  final String id;
  final String lat;
  final String lng;
  final String title;
  final String description;
  final String type;
  final String url;
  final String img;
  final String gpsPointsList;
  Sector(this.id, this.lat, this.lng, this.title,this.description,this.type,this.url,this.img,this.gpsPointsList);
  Sector.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        lat = json["lat"],
        lng = json['lng'],
        title = json['title'],
        description = json['description'],
        type = json['type'],
        url = json['url'],
        img = json['img'],
        gpsPointsList = json["gpsPointsList"];

}

class Rock extends Item {
  final String id;
  final String lat;
  final String lng;
  final String title;
  final String description;
  final String type;
  final String url;
  final String img;
  final String rockType;
  final String childSafe;
  final String hight;
  final Map<String,dynamic> routesStats;
  Rock(this.id, this.lat, this.lng, this.title,this.description,this.type,this.url,this.img, this.rockType, this.childSafe,this.hight, this.routesStats);
  Rock.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      lat = json["lat"],
      lng = json['lng'],
      title = json['title'],
      description = json['description'],
      type = json['type'],
      url = json['url'],
      img = json['img'],
      rockType = json['rockType '],
      childSafe=json['childSafe'],
      hight = json['hight'],
      routesStats = json['routesStats'];
}

class AreaSimple extends Item {
  final String id;
  final String lat;
  final String lng;
  final String title;
  final String description;
  final String type;
  final String url;
  final String img;
  AreaSimple(this.id, this.lat, this.lng, this.title,this.description,this.type,this.url,this.img);
  AreaSimple.fromJson(Map<String, dynamic> json)
      : id = "",
        lat = "",
        lng = "",
        title = "",
        description = "",
        type = "area_simple",
        url = json['url'],
        img = json['img'];

}

