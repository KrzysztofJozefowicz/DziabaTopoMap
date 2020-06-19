import 'package:flutter/material.dart';
import '../dataProvider/portalGorskiApi.dart';
import 'dart:developer';

class  appState extends ChangeNotifier {
  String _url = "";
  Item  _rockItem;
  Color favColor = Colors.transparent;
  var favorites =  <String>{""};
  List<Item> _rocks = new List();
  Map<String,bool> _filterState = _defaultFilterState();
  Map<String,dynamic> _filterContent = _defaultFilterContent() ;
  Map<String,bool> get FilterState => _filterState;

  void SetFilterState(String key, bool value)
  {
    _filterState[key] = value;
  }

  Map<String,dynamic> get FilterContent =>_filterContent ;
  void SetFilterContent(String key, dynamic value)
  {
    _filterContent[key] = value;
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
  void PopulateRocks(List<Item> rocksFromApi)
  {
    _rocks = rocksFromApi;
  }

  Item GetRockById(String id)
  {
    for (var element in _rocks)
      {
        if (element.id == id )
          {
            return element;
          }
      }
    //return null;
  }
  List<Item> get rocks => _rocks;



  static Map<String,bool>  _defaultFilterState()
  {
    Map<String,bool> filterState = new Map();
    filterState["showOnlyFavorites"]=false;
    return (filterState);
  }
  static Map<String,dynamic> _defaultFilterContent()
  {
    Map<String,dynamic> filterContent= new Map();
    filterContent["favorites"]=new List();
    return (filterContent);
  }
}


