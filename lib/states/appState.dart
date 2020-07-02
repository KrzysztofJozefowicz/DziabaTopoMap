import 'package:flutter/material.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'package:latlong/latlong.dart';
import 'dart:developer';

class  appState extends ChangeNotifier {
  String _url = "";
  Item  _rockItem;
  Color favColor = Colors.transparent;
  List<String> favorites = new List();
  Set<String> _rocksIdToDisplay = new Set();
  Map<String,Item> _rocks = new Map();
  Map<String,bool> _filterState = _defaultFilterState();
  Map<String,dynamic> _filterContent = _defaultFilterContent() ;
  Map<String,bool> get FilterState => _filterState;




  Set<Item> GetRocksItemsFromIds(Iterable ItemsId)
  {
    Set<Item> RocksItems= new Set();
    for (var element in ItemsId)
      {
        RocksItems.add(GetRockById(element));
      }
    return RocksItems;

  }
  set RocksIdToDisplay(Iterable elements) {
    _rocksIdToDisplay = new Set();
    _rocksIdToDisplay.addAll(elements);
  }

  Set<String> GetRocksIdToDisplay()
  {

    return _rocksIdToDisplay;
  }

  Set<Item> GetRocksItemsToDisplay()
  {
    Set<Item> rocksItemsToDisplay = new Set();
    for (var element in _rocksIdToDisplay)
      {
        rocksItemsToDisplay.add(GetRockById(element));
      }
    return rocksItemsToDisplay;
  }

  void SetFilterState(String key, bool value)
  {
    _filterState[key] = value;
    notifyListeners();
  }

  Map<String,dynamic> get FilterContent =>_filterContent ;
  void SetFilterContent(String key, dynamic value)
  {
    _filterContent[key] = value;
    notifyListeners();
  }

  String get url => _url;
  set url(String  value) {
    _url = value;
    notifyListeners();
  }
  void SetRockUrl(String value)
  {
      _url = value;
      notifyListeners();
  }

  Item get rockItem => _rockItem;
  set rockItem (Item value) {
    _rockItem = value;
    notifyListeners();
  }

  void SetRockItem(Item value)
  {
    _rockItem = value;
    notifyListeners();
  }

  void ClearRockItem()
  {
    _rockItem = null;
    notifyListeners();
  }

  void SetFavColor(Color color)
  {
    favColor = color;
    notifyListeners();
  }

  void AddToFavorites(String id)
  {
    if (favorites == null)
      {
        favorites.add(id);
        notifyListeners();
      }
    if (!favorites.contains(id))
      {
        favorites.add(id);
        notifyListeners();
      }
  }
  void RemoveFromFavorites(String id)
  {

    if (favorites.contains(id) && favorites != null)
      {
        favorites.remove(id);
        notifyListeners();
      }
  }
  bool IsInFavorites(String id)
  {
    if (favorites != null) {
      return favorites.contains(id);
    }
    return false;
  }
  void PopulateRocks(Map<String,Item> rocksFromApi)
  {
    _rocks = rocksFromApi;
  }

  Item GetRockById(String id)
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
    return (filterContent);
  }
}


