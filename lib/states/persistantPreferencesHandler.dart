import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
class PreferencesHandler
{

  static Future<Map<String,dynamic>> loadPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> preferences = new Map();
  for (String key in prefs.getKeys())
    {
      if (key == "favorites")
        {
          preferences[key]= prefs.getStringList(key);
        }
    }
  return  preferences;
}

  static saveFavorites(List<String> favoritesList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favorites", favoritesList);
  }
}