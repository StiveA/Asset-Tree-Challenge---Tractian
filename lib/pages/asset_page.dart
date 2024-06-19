import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/asset.dart';
import '../models/location.dart';
import '../services/asset_service.dart';
import '../widgets/asset_tree.dart';

class AssetPage extends StatefulWidget {
  final String unit;

  const AssetPage({super.key, required this.unit});

  @override
  _AssetPageState createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final AssetService assetService = AssetService();
  List<Location> locations = [];
  List<Asset> assets = [];
  String searchQuery = '';
  bool isLoading = true;
  bool filterCritical = false;
  bool filterEnergySensor = false;
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Widget? _suffixIcon = IconButton(
    icon: const Icon(Icons.search),
    disabledColor: AppColors().appColors["on_light_surface"],
    onPressed: null,
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void _updateSuffixIcon(bool isNotEmpty) {
    setState(() {
      _suffixIcon = isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                _searchTextFieldController.clear();
                _updateSuffixIcon(false);
                updateSearchQuery('');
              },
            )
          : IconButton(
              icon: const Icon(Icons.search),
              disabledColor: AppColors().appColors["on_light_surface"],
              onPressed: null,
            );
    });
  }

  void loadData() async {
    final loadedLocations = await assetService.getLocations(widget.unit);
    final loadedAssets = await assetService.getAssets(widget.unit);
    setState(() {
      locations = loadedLocations;
      assets = loadedAssets;
      isLoading = false;
    });
  }

  void updateSearchQuery(String query) {
    _updateSuffixIcon(query.isNotEmpty);
    setState(() {
      searchQuery = query;
    });
  }

  void toggleCriticalFilter() {
    setState(() {
      filterCritical = !filterCritical;
    });
  }

  void toggleEnergySensorFilter() {
    setState(() {
      filterEnergySensor = !filterEnergySensor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors().appColors;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: colors["white"]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Assets - ${widget.unit.replaceAll('_', ' ').toUpperCase()}',
            style:
                TextStyle(color: colors["white"], fontWeight: FontWeight.bold),
          ),
          backgroundColor: colors["dark_blue"],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: widget.key,
                      strutStyle: const StrutStyle(
                        fontSize: 16,
                        height: 1.0,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: colors["focused_border"],
                      onFieldSubmitted: (_) {
                        _searchFocusNode.unfocus();
                      },
                      onTapOutside: (_) {
                        _searchFocusNode.unfocus();
                      },
                      onChanged: updateSearchQuery,
                      focusNode: _searchFocusNode,
                      style: TextStyle(
                        color: colors["black"],
                        fontSize: 16,
                      ),
                      controller: _searchTextFieldController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        labelText: "Search",
                        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
                          (Set<WidgetState> states) {
                            Color? labelColor;
                            if (states.contains(WidgetState.error)) {
                              labelColor = colors["error"];
                            } else {
                              labelColor = colors["focused_border"];
                            }
                            return TextStyle(
                                color: labelColor, fontWeight: FontWeight.bold);
                          },
                        ),
                        filled: true,
                        fillColor: colors["fillColor"],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: colors["enabled_border"]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: colors["focused_border"]!, width: 1),
                        ),
                        suffixIcon: _suffixIcon,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: toggleCriticalFilter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: filterCritical
                                ? colors["light_blue"]
                                : colors["grey"],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text('Critical',
                              style: TextStyle(
                                  fontSize: 12, color: colors["white"])),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: toggleEnergySensorFilter,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: filterEnergySensor
                                ? colors["light_blue"]
                                : colors["grey"],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text('Energy Sensor',
                              style: TextStyle(
                                  fontSize: 12, color: colors["white"])),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AssetTree(
                      locations: locations,
                      assets: assets,
                      searchQuery: searchQuery,
                      filterCritical: filterCritical,
                      filterEnergySensor: filterEnergySensor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
