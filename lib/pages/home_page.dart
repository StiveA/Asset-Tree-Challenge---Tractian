import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'asset_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final List<String> units = ['apex_unit', 'jaguar_unit', 'tobias_unit'];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors().appColors;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'T R A C T I A N',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: colors["dark_blue"],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Select a unit to view assets',
                style: TextStyle(
                  color: colors["black"],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: units.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: const Color.fromRGBO(33, 136, 255, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      iconColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      leading: const Icon(Icons.apartment),
                      title: Text(
                        units[index].replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssetPage(unit: units[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
