import 'package:flutter/material.dart';
import '../dataProvider/portalGorskiApi.dart';
class  appState extends ChangeNotifier {
  String _url = "";
  Item  _rockItem;

  String get url => _url;
  set url(String  value) {
    _url = value;
    notifyListeners();
  }

  Item get rockItem => _rockItem;
  set rockItem (Item value) {
    _rockItem = value;
    notifyListeners();
  }

  }
