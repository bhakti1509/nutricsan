// ignore_for_file: use_key_in_widget_constructors, camel_case_types, library_private_types_in_public_api, avoid_print, prefer_const_constructors, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/details_additives.dart';

class additives extends StatefulWidget {
  @override
  _additivesState createState() => _additivesState();
}

class _additivesState extends State<additives> {
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'Preservatives'; // Default category

  @override
  void initState() {
    super.initState();
    // Load data for the default category
    loadCsvDataForCategory(selectedCategory);
  }

  Future<void> loadCsvDataForCategory(String category) async {
    String csvFileName =
        'assets/additves_data/preservativesE200-E299.csv'; // Set this based on the category
    switch (category) {
      case 'Preservatives':
        csvFileName = 'assets/additves_data/preservativesE200-E299.csv';
        break;
      case 'Colors':
        csvFileName = 'assets/additves_data/colorsE100-E199.csv';
        break;
      case 'Emulsifiers':
        csvFileName = 'assets/additves_data/emulsifiersE400-E499.csv';
        break;
      case 'Acidity Regulators':
        csvFileName = 'assets/additves_data/AcidityRegE500-E599.csv';
        break;
      case 'Additional additives':
        csvFileName = 'assets/additves_data/AdditionalAdditivesE1000-E1599.csv';
        break;
      case 'Antibiotics':
        csvFileName = 'assets/additves_data/AntibioticsE700-E799.csv';
        break;
      case 'Antioxidants':
        csvFileName = 'assets/additves_data/antioxidantsE300-E399.csv';
        break;
      case 'Flavour Enhancers':
        csvFileName = 'assets/additves_data/FlavourEnhancerE600-E699.csv';
        break;
      case 'Glazing Agents':
        csvFileName = 'assets/additves_data/GlazingAgentsE900-E999.csv';
        break;
      // Add cases for other categories as needed
    }

    List<List<dynamic>> csvData = await rootBundle
        .loadString(csvFileName)
        .then((csvString) => const CsvToListConverter().convert(csvString));
    csvData.removeWhere((row) => row.length < 2);

    setState(() {
      this.csvData = csvData;
      filteredData = csvData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Additives", style: TextStyle(color: Colors.white)),
        backgroundColor: Blue1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                  loadCsvDataForCategory(selectedCategory);
                });
              },
              items: <String>[
                'Preservatives',
                'Colors',
                'Emulsifiers',
                'Acidity Regulators',
                'Additional additive', 'Antibiotics', 'Antioxidants',
                'Flavour Enhancers', 'Glazing Agents'

                // Add other category options here
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                hintText: 'Enter text to search',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final code = filteredData[index + 1][0];
                final name = filteredData[index + 1][1];
                final purpose = filteredData[index + 1][2];
                final content = filteredData[index + 1][3];
                final status = filteredData[index + 1][4];
                final searchText = _searchController.text.toLowerCase();
                final nameLowerCase = name.toLowerCase();
                final bool matchesSearch =
                    searchText.isEmpty || nameLowerCase.contains(searchText);
                if (matchesSearch) {
                  if (matchesSearch) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsAdditives(
                              code.toString(),
                              name.toString(),
                              purpose.toString(),
                              content.toString(),
                              status.toString(),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        child: Card(
                          borderOnForeground: true,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.all(0),
                            leading: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Blue1),
                              width: 80.0,
                              child: Center(
                                child: Text(
                                  code.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            title: Text(name.toString()),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String searchText) {
    setState(() {
      _searchController.text = searchText;
    });
  }
}
