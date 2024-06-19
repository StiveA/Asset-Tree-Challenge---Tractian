import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/asset.dart';
import '../models/location.dart';

class AssetService {
  Future<List<Location>> getLocations(String unit) async {
    final String response =
        await rootBundle.loadString('assets/$unit/locations.json');
    final data = await json.decode(response);
    List<Location> locations =
        (data as List).map((i) => Location.fromJson(i)).toList();
    return locations;
  }

  Future<List<Asset>> getAssets(String unit) async {
    final String response =
        await rootBundle.loadString('assets/$unit/assets.json');
    final data = await json.decode(response);
    List<Asset> assets = (data as List).map((i) => Asset.fromJson(i)).toList();
    return assets;
  }
}
