import 'package:http/http.dart' as http;
import 'dart:convert' show json;




Future<TopoPortalGorskiByTypes> fetchData() async {

  final response =  await http.get('http://topo.portalgorski.pl/topo/json/get/id/634');
  if (response.statusCode == 200) {
    return TopoPortalGorskiByTypes.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load API from PortalGorski');
  }
}

class TopoPortalGorski {
  final List<Item> items;

  TopoPortalGorski({this.items});

  factory TopoPortalGorski.fromJson(Map<String, dynamic> json)
  {
    List<Item> items = json['results'].map<Item>( (data)
      {
        return Item.getItemFromJson(data);
      }
    ).toList();
    return TopoPortalGorski(items: items);
  }
}

Map<String, List<Item>> groupItemsByType(Map<String, dynamic> json) {
  Map<String, List<Item>> sortedItems = {
    "area": List<Item>(),
    "area_simple": List<Item>(),
    "rock": List<Item>(),
    "sector": List<Item>()
  };
  List<dynamic> results = json['results'];
  results.forEach((item) {
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
  });
  return sortedItems;
}
class TopoPortalGorskiByTypes {
  final Map<String, List<Item>> items;

  TopoPortalGorskiByTypes({this.items});

  factory TopoPortalGorskiByTypes.fromJson(Map<String, dynamic> json)
  {
    Map<String, List<Item>> items;
    items=groupItemsByType(json);
    return TopoPortalGorskiByTypes(items: items);
  }


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
  Rock(this.id, this.lat, this.lng, this.title,this.description,this.type,this.url,this.img);
  Rock.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      lat = json["lat"],
      lng = json['lng'],
      title = json['title'],
      description = json['description'],
      type = json['type'],
      url = json['url'],
      img = json['img'];
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

