import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../model/location_model.dart';

class LocationData {
  static List<LocationModel> regions = [];
  static List<LocationModel> cities = [];
  static List<LocationModel> villages = [];
  static Map<String, dynamic>? _cachedJson;

  static Future<void> loadPlaces(BuildContext context) async {
    try {
      if (_cachedJson == null) {
        final String jsonString = await DefaultAssetBundle.of(context).loadString('assets/places.json');
        _cachedJson = jsonDecode(jsonString);
      }

      regions = await Future.wait(
        (_cachedJson!['regions'] as List<dynamic>)
            .map((region) => LocationModel.fromJson(region)),
      );
      cities = await Future.wait(
        (_cachedJson!['cities'] as List<dynamic>)
            .map((city) => LocationModel.fromJson(city)),
      );
      villages = await Future.wait(
        (_cachedJson!['villages'] as List<dynamic>)
            .map((village) => LocationModel.fromJson(village)),
      );
      debugPrint('Locations loaded successfully');
    } catch (e) {
      debugPrint('Error loading places.json: $e');
    }
  }
}