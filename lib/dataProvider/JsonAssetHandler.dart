import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class JsonObject {
  String defaultJsonAssetPath = 'assets/rockApiData.json';
  String currentJsonAssetPath;

  JsonObject() {
    this.currentJsonAssetPath = defaultJsonAssetPath;
  }

  String getJsonAssetPath()
  {
    return this.currentJsonAssetPath;
  }

  void setJsonAssetPath(String assetPath)
  {
    this.currentJsonAssetPath=assetPath;
  }
  Future<String>  getJsonFromUrl(String url) async{
    //TODO
    https://pub.dev/packages/download_assets
    log("downloading json from url:" + url);
    String filename='test.json';
    String dir = (await getApplicationDocumentsDirectory()).path;
    var req = await Client().get(Uri.parse(url));
    var file = File(req.bodyBytes,'$dir/$filename');
    return  '$dir/$filename';
  }

  bool validateJson(String jsonFile) {
    //TODO
    return true;
  }

  getNewJsonAndActivateIt(String urlToJson) {
    String localJsonPath= this.getJsonFromUrl(urlToJson);
    if (validateJson(localJsonPath)) {
      this.currentJsonAssetPath = localJsonPath;
    } else {
      this.cleanUp(localJsonPath);
    }
  }

  revertJsonToDefault() {
    this.currentJsonAssetPath = defaultJsonAssetPath;
  }

  cleanUp(String jsonFilePath) {
    //TODO
    log("removing jsonFilePath: " + jsonFilePath);
  }
}
