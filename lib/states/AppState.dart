import 'package:flutter/material.dart';
import '../dataProvider/RockLoader.dart';
import 'package:latlong/latlong.dart';
import 'dart:developer';
import '../dataProvider/JsonHandler.dart';
import '../states/persistantPreferencesHandler.dart';

class  AppState extends ChangeNotifier {
  String _url = "";
  Item  _rockItem;
  Color favColor = Colors.transparent;
  List<String> favorites = new List();
  Set<String> _rocksIdToDisplay = new Set();
  Map<String,Item> _rocks = new Map();
  Map<String,bool> _filterState = _defaultFilterState();
  Map<String,dynamic> filterContent = _defaultFilterContent() ;
  Map<String,bool> get filterState => _filterState;
  bool isLoadedFromSharedPrefs = false;
  LatLng currentUserLocation;
  LatLng currentMapLocation;

  JsonObject jsonAsset = new JsonObject();

  set rocksIdToDisplay(Iterable elements) {
    _rocksIdToDisplay = new Set();
    _rocksIdToDisplay.addAll(elements);
  }



  Set<Item> getRocksItemsToDisplay()
  {
    Set<Item> rocksItemsToDisplay = new Set();
    for (var element in _rocksIdToDisplay)
      {
        rocksItemsToDisplay.add(getRockById(element));
      }
    return rocksItemsToDisplay;
  }

  void setFilterState(String key, bool value)
  {
    _filterState[key] = value;
    notifyListeners();
  }


  void setFilterContent(String key, dynamic value)
  {
    filterContent[key] = value;
    notifyListeners();
  }





  Item get rockItem => _rockItem;
  set rockItem (Item value) {
    _rockItem = value;
    notifyListeners();
  }



  void clearRockItem()
  {
    _rockItem = null;
    notifyListeners();
  }



  void addToFavorites(String id)
  {
    if (favorites == null)
      {
        favorites.add(id);
        PreferencesHandler.saveFavorites(favorites);
        notifyListeners();
      }
    if (!favorites.contains(id))
      {
        favorites.add(id);
        PreferencesHandler.saveFavorites(favorites);
        notifyListeners();
      }
  }
  void removeFromFavorites(String id)
  {

    if (favorites.contains(id) && favorites != null)
      {
        favorites.remove(id);
        PreferencesHandler.saveFavorites(favorites);
        notifyListeners();
      }
  }
  bool isInFavorites(String id)
  {
    if (favorites != null) {
      return favorites.contains(id);
    }
    return false;
  }
  void populateRocks(Map<String,Item> rocksFromApi)
  {
    _rocks = rocksFromApi;
  }

  Item getRockById(String id)
  {
    return _rocks[id];
  }
  Map<String,Item> get rocks => _rocks;



  static Map<String,bool>  _defaultFilterState()
  {
    Map<String,bool> filterState = new Map();
    filterState["showOnlyFavorites"]=false;
    filterState["includeWithIII"]=false;
    filterState["includeWithIV"]=false;
    filterState["includeWithV"]=false;
    filterState["includeWithVI"]=false;
    filterState["includeWithVI.1"]=false;
    filterState["includeWithVI.2"]=false;
    filterState["includeWithVI.3"]=false;
    filterState["includeWithVI.4"]=false;
    filterState["includeWithVI.5"]=false;
    filterState["includeWithVI.6"]=false;
    filterState["includeWithVI.7"]=false;
    filterState["includeWithVI.8"]=false;
    return (filterState);
  }
  static Map<String,dynamic> _defaultFilterContent()
  {
    Map<String,dynamic> filterContent= new Map();
    filterContent["favorites"]=new List();
    filterContent["includeWithIII"]="III";
    filterContent["includeWithIV"]="IV";
    filterContent["includeWithV"]="V";
    filterContent["includeWithVI"]="VI";
    filterContent["includeWithVI.1"]="VI.1";
    filterContent["includeWithVI.2"]="VI.2";
    filterContent["includeWithVI.3"]="VI.3";
    filterContent["includeWithVI.4"]="VI.4";
    filterContent["includeWithVI.5"]="VI.5";
    filterContent["includeWithVI.6"]="VI.6";
    filterContent["includeWithVI.7"]="VI.7";
    filterContent["includeWithVI.8"]="VI.8";
    return (filterContent);
  }

   void loadFromPreferences (Future <Map<String,dynamic>> preferenceMap) async{
    Map<String,dynamic> loadedPreferences = await preferenceMap;
    for (String key in loadedPreferences.keys)
      {
        if (key == "favorites")
        {
          for (var item in loadedPreferences[key]) {
            addToFavorites(item);
            filterContent[key] = favorites;
          }
        }

      }

  }
}



