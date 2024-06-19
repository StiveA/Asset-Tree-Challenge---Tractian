import '../models/asset.dart';
import '../models/location.dart';

bool applyFilters(Asset asset, String searchQuery, bool filterCritical,
    bool filterEnergySensor) {
  bool matchesSearch =
      asset.name.toLowerCase().contains(searchQuery.toLowerCase());
  bool matchesCriticalFilter =
      !filterCritical || (asset.status != null && asset.status == 'alert');
  bool matchesEnergySensorFilter = !filterEnergySensor ||
      (asset.sensorType != null && asset.sensorType == 'energy');

  return matchesSearch && matchesCriticalFilter && matchesEnergySensorFilter;
}

bool shouldShowLocation(
    Location location,
    Map<String, List<Asset>> assetMap,
    Map<String, List<Location>> locationMap,
    String searchQuery,
    bool filterCritical,
    bool filterEnergySensor) {
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
    if (shouldShowLocation(subLocation, assetMap, locationMap, searchQuery,
        filterCritical, filterEnergySensor)) {
      return true;
    }
  }
  for (var asset in assetMap[location.id] ?? []) {
    if (applyFilters(asset, searchQuery, filterCritical, filterEnergySensor)) {
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
