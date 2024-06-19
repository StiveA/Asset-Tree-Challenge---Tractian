Asset Tree View Application
This Flutter application provides a dynamic tree structure visualization of a company's assets, including components, assets, and locations. The tree view helps visualize the hierarchy and manage the maintenance of industrial assets, such as manufacturing equipment, transportation vehicles, and power generation systems.

Features
1. Home Page
A menu for users to navigate between different companies and access their assets.
2. Asset Page
The core feature, offering a visual tree representation of the company's asset hierarchy.
Sub-Features:
Visualization
Displays a dynamic tree structure of components, assets, and locations.
Filters
Text Search: Users can search for specific components, assets, or locations within the asset hierarchy. The search results will display the entire hierarchy path to the matched item.
Energy Sensors: Filter to isolate energy sensors within the tree.
Critical Sensor Status: Filter to identify assets with critical sensor status. When filters are applied, the entire asset path is displayed, ensuring parents are visible even if not directly related to the filter.

Technical Data
Locations Collection
Contains only locations and sub-locations.
Composed of name, id, and an optional parentId.
Example:
{
    "name": "PRODUCTION AREA - RAW MATERIAL",
    "parentId": null,
    "id": "65674204664c41001e91ecb4"
}


Asset Tree View Application
This Flutter application provides a dynamic tree structure visualization of a company's assets, including components, assets, and locations. The tree view helps visualize the hierarchy and manage the maintenance of industrial assets, such as manufacturing equipment, transportation vehicles, and power generation systems.

Features
1. Home Page
A menu for users to navigate between different companies and access their assets.
2. Asset Page
The core feature, offering a visual tree representation of the company's asset hierarchy.
Sub-Features:
Visualization
Displays a dynamic tree structure of components, assets, and locations.
Filters
Text Search: Users can search for specific components, assets, or locations within the asset hierarchy. The search results will display the entire hierarchy path to the matched item.
Energy Sensors: Filter to isolate energy sensors within the tree.
Critical Sensor Status: Filter to identify assets with critical sensor status. When filters are applied, the entire asset path is displayed, ensuring parents are visible even if not directly related to the filter.
Technical Data
Locations Collection
Contains only locations and sub-locations.
Composed of name, id, and an optional parentId.
Example:
json
Copiar código
{
    "name": "PRODUCTION AREA - RAW MATERIAL",
    "parentId": null,
    "id": "65674204664c41001e91ecb4"
}

Assets Collection
Contains assets, sub-assets, and components.
Composed of name, id, and optional locationId, parentId, and sensorType.
If the item has a sensorType, it is a component. If it does not have a location or a parentId, it is unlinked from any asset or location in the tree.
Example:
{
    "name": "Fan - External",
    "parentId": null,
    "sensorType": "energy",
    "status": "operating",
    "locationId": null,
    "id": "656734821f4664001f296973"
}

Folder Structure
assets/
  apex_unit/
    assets.json
    locations.json
  jaguar_unit/
    assets.json
    locations.json
  tobias_unit/
    assets.json
    locations.json
lib/
  models/
    asset.dart
    location.dart
  services/
    asset_service.dart
  widgets/
    asset_tree.dart
  constants/
    app_colors.dart
  main.dart
  asset_page.
  
Usage
Running the App
Ensure Flutter SDK is installed.
Clone the repository.
Navigate to the project directory.
Run flutter pub get to install dependencies.
Use flutter run to start the application.
Asset Tree Widget
The AssetTree widget takes in lists of locations and assets, and parameters for search and filters. It builds a tree view that updates dynamically based on user input.
Asset Service
The AssetService fetches location and asset data from JSON files specific to each unit. This allows the app to switch between different units and display the corresponding assets and locations.
Filters and Search
Filters and search functionality ensure that users can easily locate specific assets and view their status. The tree structure remains intact, showing the full path to any matched items.




