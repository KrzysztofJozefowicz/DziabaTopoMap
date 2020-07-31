import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, Map<String, Item>>> fetchData() async {
  return await loadAsset();
}

Future<Map<String, Map<String, Item>>> loadAsset() async {
  final response = await rootBundle.loadString('assets/rockApiData.json');
  return groupItemsByType(json.decode(response));
}

Map<String, Map<String, Item>> groupItemsByType(Map<String, dynamic> json) {
  Map<String, Map<String, Item>> sortedItems = {
    "rock": Map<String, Rock>(),
  };

  for (Map<String, dynamic> item in json.values) {
    Item i = Item.getItemFromJson(item);
      sortedItems["rock"][i.id] = i;
      }
  return sortedItems;
}

class InfoPage{
  String displayName;
  String url;
  InfoPage(String dislayName,String url)
  {
    this.displayName=dislayName;
    this.url = url;
  }
}
abstract class Item {
  String id;
  String lat;
  String lng;
  String title;
  String description;
  List<InfoPage> infoPage;
  String img;

  Item();

  factory Item.getItemFromJson(Map<String, dynamic> json) {
      return Rock.fromJson(json);
  }
}

class Rock extends Item {
  final String id;
  final String lat;
  final String lng;
  final String title;
  final String description;
  final List<InfoPage> infoPage;
  final String rockType;
  final String childSafe;
  final String hights;

  final Map<String, int> routesStatsSimplified;

  Rock(this.id, this.lat, this.lng, this.title, this.description, this.infoPage, this.rockType, this.childSafe, this.hights,
      this.routesStatsSimplified);

  Rock.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        lat = json["lat"],
        lng = json['lng'],
        title = json['title'],
        description = json['description'],
        infoPage = _populateInfoPage(json['infoPage']),
        rockType = returnStringOrEmptyString(json['rockType']),
        childSafe = returnStringOrEmptyString(json['childSafe']),
        hights = returnStringOrEmptyString(json['hights']),
        routesStatsSimplified = _countRoutes(json['routesStats']);
}

String returnStringOrEmptyString(String json)
{
  String returnString = "";
  if (json != null)
    {
      returnString=json;
    }
  return returnString;
}
List<InfoPage> _populateInfoPage(List<dynamic> jsonInfoPage)
{
  List<InfoPage> internalInfoPage = new List();
  for (var element in jsonInfoPage)
    {
      for (var key in element.keys)
        {
          internalInfoPage.add(InfoPage(key,element[key]));
        }

    }
  return(internalInfoPage);

}
Map<String, int> _countRoutes(Map<String, dynamic> routesStats) {
  Map<String, int> routesCount = {
    "III": 0,
    'IV': 0,
    'V': 0,
    'VI': 0,
    'VI.1': 0,
    'VI.2': 0,
    'VI.3': 0,
    'VI.4': 0,
    'VI.5': 0,
    'VI.6': 0,
    'VI.7': 0,
    'VI.8': 0
  };
  for (var element in routesStats.keys) {
    if (element.contains(new RegExp(r'II.*')) || element.contains(new RegExp(r'III.*'))) {
      routesCount['III'] += int.parse(routesStats[element]);
      continue;
    }

    if (element.contains(new RegExp(r'IV.*'))) {
      routesCount['IV'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'V[-+]'))) {
      routesCount['V'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI[-+]'))) {
      routesCount['VI'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.1.*'))) {
      routesCount['VI.1'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.2.*'))) {
      routesCount['VI.2'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.3.*'))) {
      routesCount['VI.3'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.4.*'))) {
      routesCount['VI.4'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.5.*'))) {
      routesCount['VI.5'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.6.*'))) {
      routesCount['VI.6'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.7.*'))) {
      routesCount['VI.7'] += int.parse(routesStats[element]);
      continue;
    }
    if (element.contains(new RegExp(r'VI\.8.*'))) {
      routesCount['VI.8'] += int.parse(routesStats[element]);
      continue;
    }
  }
  return routesCount;
}
