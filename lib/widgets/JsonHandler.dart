import 'package:flutter/cupertino.dart';
import 'dart:developer';


class JsonObject
{
  String defaultJsonAssetPath='assets/rockApiData.json';
  String currentJsonAssetPath;
  JsonObject()
  {
    this.currentJsonAssetPath=defaultJsonAssetPath;
  }
   String getJsonFromUrl(String url)
  {
    //TODO
    log("downloading json from url:"+url);
    return("testPath");
  }
  String getActiveJsonAssetPath()
  {
    return this.currentJsonAssetPath;
  }
  bool validateJson(String jsonFile)
  {
    //TODO
    return true;
  }

  getNewJsonAndActivateIt(String jsonFilePath)
  {

    if (validateJson(jsonFilePath))
    {
      this.currentJsonAssetPath=jsonFilePath;
    }
    else
      {
        this.cleanUp(jsonFilePath);
      }
  }

  revertJsonToDefault()
  {
    this.currentJsonAssetPath=defaultJsonAssetPath;
  }

  cleanUp(String jsonFilePath)
  {
    //TODO
    log("removing jsonFilePath: "+jsonFilePath);
  }

}

