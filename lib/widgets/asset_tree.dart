import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/asset.dart';
import '../models/location.dart';

class AssetTree extends StatelessWidget {
  final List<Location> locations;
  final List<Asset> assets;
  final String searchQuery;
  final bool filterCritical;
  final bool filterEnergySensor;

  const AssetTree({
    super.key,
    required this.locations,
    required this.assets,
    required this.searchQuery,
    required this.filterCritical,
    required this.filterEnergySensor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: buildTree(),
    );
  }

  List<Widget> buildTree() {
    List<Widget> tree = [];
    Map<String, List<Asset>> assetMap = {};
    Map<String, List<Location>> locationMap = {};

    for (var asset in assets) {
      if (asset.locationId != null) {
        assetMap.putIfAbsent(asset.locationId!, () => []).add(asset);
      } else if (asset.parentId != null) {
        assetMap.putIfAbsent(asset.parentId!, () => []).add(asset);
      } else {
        tree.add(buildComponent(asset));
      }
    }

    for (var location in locations) {
      locationMap
          .putIfAbsent(location.parentId ?? 'root', () => [])
          .add(location);
    }

    for (var location in locationMap['root'] ?? []) {
      var locationWidget = buildLocation(location, assetMap, locationMap);
      if (locationWidget != null) {
        tree.add(locationWidget);
      }
    }

    return tree;
  }

  bool applyFilters(Asset asset) {
    bool matchesSearch =
        asset.name.toLowerCase().contains(searchQuery.toLowerCase());
    bool matchesCriticalFilter =
        !filterCritical || (asset.status != null && asset.status == 'alert');
    bool matchesEnergySensorFilter = !filterEnergySensor ||
        (asset.sensorType != null && asset.sensorType == 'energy');

    return matchesSearch && matchesCriticalFilter && matchesEnergySensorFilter;
  }

  bool shouldShowLocation(Location location, Map<String, List<Asset>> assetMap,
      Map<String, List<Location>> locationMap) {
    if (filterCritical &&
        !hasCriticalChildren(location.id, assetMap, locationMap)) {
      return false;
    }
    if (filterEnergySensor &&
        !hasEnergySensorChildren(location.id, assetMap, locationMap)) {
      return false;
    }

    if (location.name.toLowerCase().contains(searchQuery.toLowerCase())) {
      return true;
    }
    for (var subLocation in locationMap[location.id] ?? []) {
      if (shouldShowLocation(subLocation, assetMap, locationMap)) {
        return true;
      }
    }
    for (var asset in assetMap[location.id] ?? []) {
      if (applyFilters(asset)) {
        return true;
      }
    }
    return false;
  }

  bool hasCriticalChildren(String id, Map<String, List<Asset>> assetMap,
      Map<String, List<Location>> locationMap) {
    for (var asset in assetMap[id] ?? []) {
      if (asset.status == 'alert') {
        return true;
      }
      if (hasCriticalChildren(asset.id, assetMap, locationMap)) {
        return true;
      }
    }
    for (var location in locationMap[id] ?? []) {
      if (hasCriticalChildren(location.id, assetMap, locationMap)) {
        return true;
      }
    }
    return false;
  }

  bool hasEnergySensorChildren(String id, Map<String, List<Asset>> assetMap,
      Map<String, List<Location>> locationMap) {
    for (var asset in assetMap[id] ?? []) {
      if (asset.sensorType == 'energy') {
        return true;
      }
      if (hasEnergySensorChildren(asset.id, assetMap, locationMap)) {
        return true;
      }
    }
    for (var location in locationMap[id] ?? []) {
      if (hasEnergySensorChildren(location.id, assetMap, locationMap)) {
        return true;
      }
    }
    return false;
  }

  Widget? buildLocation(Location location, Map<String, List<Asset>> assetMap,
      Map<String, List<Location>> locationMap) {
    bool shouldDisplayLocation =
        shouldShowLocation(location, assetMap, locationMap);

    List<Widget> children = [];

    for (var subLocation in locationMap[location.id] ?? []) {
      var subLocationWidget = buildLocation(subLocation, assetMap, locationMap);
      if (subLocationWidget != null) {
        children.add(subLocationWidget);
      }
    }

    for (var asset in assetMap[location.id] ?? []) {
      var assetWidget = buildAsset(asset, assetMap, locationMap);
      if (assetWidget != null) {
        children.add(assetWidget);
      }
    }

    bool hasCritical = hasCriticalChildren(location.id, assetMap, locationMap);

    if (children.isEmpty && !shouldDisplayLocation) {
      return null;
    }

    if (children.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: ListTile(
          leading: Image.asset("assets/images/location.png"),
          title: Row(
            children: [
              Text(location.name),
              if (hasCritical)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                      Icon(Icons.warning, color: AppColors().appColors["red"]!),
                ),
            ],
          ),
        ),
      );
    }

    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      initiallyExpanded: searchQuery.isNotEmpty,
      childrenPadding: const EdgeInsets.only(left: 16),
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Image.asset("assets/images/location.png"),
          ),
          Text(location.name),
          if (hasCritical)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(Icons.warning, color: AppColors().appColors["red"]!),
            ),
        ],
      ),
      children: children,
    );
  }

  Widget? buildAsset(Asset asset, Map<String, List<Asset>> assetMap,
      Map<String, List<Location>> locationMap) {
    bool shouldDisplayAsset = applyFilters(asset);

    List<Widget> children = [];

    for (var subAsset in assetMap[asset.id] ?? []) {
      var subAssetWidget = buildAsset(subAsset, assetMap, locationMap);
      if (subAssetWidget != null) {
        children.add(subAssetWidget);
      }
    }

    bool hasCritical = hasCriticalChildren(asset.id, assetMap, locationMap);

    if (children.isEmpty && !shouldDisplayAsset) {
      return null;
    }

    if (children.isEmpty) {
      return buildComponent(asset);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        initiallyExpanded: searchQuery.isNotEmpty,
        childrenPadding: const EdgeInsets.only(left: 16),
        dense: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Image.asset("assets/images/sub_asset_component.png"),
            ),
            Text(asset.name),
            if (hasCritical)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    Icon(Icons.warning, color: AppColors().appColors["red"]!),
              ),
          ],
        ),
        children: children,
      ),
    );
  }

  Widget buildComponent(Asset component) {
    if (!applyFilters(component)) {
      return Container();
    }

    String icon;
    switch (component.sensorType) {
      case 'vibration':
        icon = "three_component.png";
        break;
      case 'energy':
        icon = "sub_asset_component.png";
        break;
      default:
        icon = "sub_asset_component.png";
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ListTile(
        leading: Image.asset("assets/images/$icon"),
        title: Text(component.name),
        subtitle: Row(
          children: [
            Text(component.status ?? ''),
            if (component.sensorType != null &&
                component.sensorType == 'energy')
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Icon(Icons.bolt,
                    color: component.status == 'alert'
                        ? AppColors().appColors["red"]!
                        : AppColors().appColors["green"]!),
              ),
            if (component.sensorType == 'vibration' &&
                component.status == 'alert')
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child:
                    Icon(Icons.warning, color: AppColors().appColors["red"]!),
              ),
          ],
        ),
      ),
    );
  }
}
