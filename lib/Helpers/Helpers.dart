import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dataProvider/RockLoader.dart';
import 'dart:developer';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Set<String> ApplyFilters(
    Map<String, Item> itemsToFilter, Map<String, bool> filtersState, Map<String, dynamic> filtersContent) {
  Set<String> filteredItems = new Set();

  Map<String, Rock> rocks = itemsToFilter;

  filteredItems.addAll(rocks.keys);

  if (filtersState["showOnlyFavorites"] == true) {
    for (var rockId in rocks.keys) {
      if (filtersContent["favorites"].contains(rockId) != true) {
        filteredItems.remove(rockId);
      }
    }
  }

  for (var filter in filtersState.keys) {
    if (filtersState[filter] == true) {
      String currentRouteLevel = filtersContent[filter];
      for (var rock in rocks.values) {
        if (rock.routesStatsSimplified[currentRouteLevel] == 0) {
          filteredItems.remove(rock.id);
        }
      }
    }
  }
  return filteredItems;
}
