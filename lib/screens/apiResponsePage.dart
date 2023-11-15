// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/details_additives.dart';
import 'package:nutriscan/screens/home_screen.dart';
import 'package:nutriscan/widgets/extra_info.dart';

class ApiResponsePage extends StatelessWidget {
  final Map<String, dynamic>? ingredientsJsonResponse;
  final Map<String, dynamic>? nutriJsonResponse;

  ApiResponsePage({
    required this.ingredientsJsonResponse,
    required this.nutriJsonResponse,
  });

  Widget buildIngredientsList(
      Map<String, dynamic>? ingredientsJsonResponse, BuildContext context) {
    final GlobalKey _tooltipKey = GlobalKey();

    void _showTooltip() {
      final dynamic tooltip = _tooltipKey.currentState;
      tooltip.showTooltip();
    }

    if (ingredientsJsonResponse == null) {
      return Text("No ingredients found.");
    } else {
      var ingredients = ingredientsJsonResponse['ingredients'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_outline),
              color: Blue1,
              onPressed: () => _showAlertDialog(
                  context, "These are ingredients found in your packet"),
            ),
            title: Text(
              "Ingredients:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: ListTile(
              title: Text(' $ingredients'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (ingredientsJsonResponse['additives'].length == 0)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Additives:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('No Additives detected'),
            )
          else
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              trailing: IconButton(
                icon: Icon(Icons.info_outline),
                color: Blue1,
                onPressed: () => _showAlertDialog(context,
                    "These are additives detected in ingredients,to know more about it tap on additive"),
              ),
              title: Text("Additives:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ingredientsJsonResponse['additives']
                      .map<Widget>((additives) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsAdditives(
                                  additives['code'].toString(),
                                  additives['name'].toString(),
                                  additives['purpose'].toString(),
                                  additives['content'].toString(),
                                  additives['status'].toString(),
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              semanticContainer: true,
                              shape: Border.all(color: Colors.transparent),
                              elevation: 0.5,
                              child: Text(
                                ' ${additives['name']}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0), // Add spacing between addresses
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (ingredientsJsonResponse['allergen_info'].length == 0)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Allergen Information: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("No Allergens detected"),
            )
          else
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Allergen Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredientsJsonResponse['allergen_info']
                    .entries
                    .map<Widget>((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: Border.all(color: Colors.transparent),
                          elevation: 0.5,
                          child: Text(entry.value.toString()),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (ingredientsJsonResponse['ingredients_info'].length == 0)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Ingredients Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("No restricted ingredients detected"),
            )
          else
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text("Ingredients Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredientsJsonResponse['ingredients_info']
                    .entries
                    .map<Widget>((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: Border.all(color: Colors.transparent),
                          elevation: 0.5,
                          child: Text(entry.value.toString()),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      );
    }
  }

  Color getNutriScoreColor(String score) {
    switch (score) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color getNutritionCommentColor(String comment) {
    if (comment.toLowerCase().contains("high")) {
      return Colors.red;
    } else if (comment.toLowerCase().contains("medium")) {
      return Colors.yellow;
    } else if (comment.toLowerCase().contains("low")) {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }

  Map<String, int> scoreToStep = {
    'A': 1,
    'B': 2,
    'C': 3,
    'D': 4,
    'E': 5,
  };

  Widget buildNutritionList(
      Map<String, dynamic>? nutriJsonResponse, BuildContext context) {
    if (nutriJsonResponse == null) {
      return Text("No nutrition table found.");
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              "Nutritional Information:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: nutriJsonResponse['Table'].entries.map<Widget>((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(entry.key),
                      subtitle: Text(entry.value.toString()),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Nutri Score:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: ListTile(
                  title: Row(
                children: ['A', 'B', 'C', 'D', 'E'].map((score) {
                  return Container(
                    width: nutriJsonResponse['Nutri Score'] == score
                        ? 55.0
                        : 40.0, // Adjust the width as needed
                    height: nutriJsonResponse['Nutri Score'] == score
                        ? 55.0
                        : 40.0, // Adjust the height as needed
                    margin: EdgeInsets.all(0.0), // Adjust the margin as needed
                    decoration: BoxDecoration(
                      color: getNutriScoreColor(score),
                      shape: BoxShape.rectangle,
                    ),
                    child: Center(
                      child: Text(
                        score,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: nutriJsonResponse['Nutri Score'] == score
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ))),
          SizedBox(
            height: 20,
          ),
          if (nutriJsonResponse['Salt'] is String &&
              nutriJsonResponse['Salt'] == 'Not Important')
            ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Salt : Not Important'))
          else if (nutriJsonResponse['Salt'] is Map<String, dynamic>)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Salt : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return info(
                                title: nutriJsonResponse['Salt']['comment'] +
                                    '(${nutriJsonResponse['Salt']['percentage']})',
                                information: [salt_i1, salt_i2, salt_i3],
                                r_title: Salt_title,
                                recommenadtion: [salt_r1, salt_r2],
                                color: getNutritionCommentColor(
                                    nutriJsonResponse['Salt']['comment']
                                        .toString()),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getNutritionCommentColor(
                            nutriJsonResponse['Salt']['comment'].toString()),
                      ),
                    ),
                    title:
                        Text(nutriJsonResponse['Salt']['comment'].toString()),
                    subtitle: Text(
                        nutriJsonResponse['Salt']['percentage'].toString()),
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (nutriJsonResponse['Sugar'] is String &&
              nutriJsonResponse['Sugar'] == 'Not Important')
            ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Sugar : Not Important'))
          else if (nutriJsonResponse['Sugar'] is Map<String, dynamic>)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Sugar : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return info(
                                title: nutriJsonResponse['Sugar']['comment'] +
                                    '(${nutriJsonResponse['Sugar']['percentage']})',
                                information: [suagr_i1],
                                r_title: sugar_title,
                                recommenadtion: [sugar_r1, sugar_r2],
                                color: getNutritionCommentColor(
                                    nutriJsonResponse['Sugar']['comment']
                                        .toString()),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getNutritionCommentColor(
                            nutriJsonResponse['Sugar']['comment'].toString()),
                      ),
                    ),
                    title:
                        Text(nutriJsonResponse['Sugar']['comment'].toString()),
                    subtitle: Text(
                        nutriJsonResponse['Sugar']['percentage'].toString()),
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (nutriJsonResponse['Total Fat'] is String &&
              nutriJsonResponse['Total Fat'] == 'Not Important')
            ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Total Fat : Not Important'))
          else if (nutriJsonResponse['Total Fat'] is Map<String, dynamic>)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Total Fat : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return info(
                                title: nutriJsonResponse['Total Fat']
                                        ['comment'] +
                                    '(${nutriJsonResponse['Total Fat']['percentage']})',
                                information: [fat_i1],
                                r_title: fat_title,
                                recommenadtion: [fat_r1],
                                color: getNutritionCommentColor(
                                    nutriJsonResponse['Total Fat']['comment']
                                        .toString()),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getNutritionCommentColor(
                            nutriJsonResponse['Total Fat']['comment']
                                .toString()),
                      ),
                    ),
                    title: Text(
                        nutriJsonResponse['Total Fat']['comment'].toString()),
                    subtitle: Text(nutriJsonResponse['Total Fat']['percentage']
                        .toString()),
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          if (nutriJsonResponse['Saturated Fat'] is String &&
              nutriJsonResponse['Saturated Fat'] == 'Not Important')
            ListTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: 2, color: Colors.black.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text('Saturated Fat : Not Important'))
          else if (nutriJsonResponse['Saturated Fat'] is Map<String, dynamic>)
            ListTile(
              shape: RoundedRectangleBorder(
                side:
                    BorderSide(width: 2, color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Saturated Fat : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) {
                              return info(
                                title: nutriJsonResponse['Saturated Fat']
                                        ['comment'] +
                                    '(${nutriJsonResponse['Saturated Fat']['percentage']})',
                                information: [fat_i1],
                                r_title: fat_title,
                                recommenadtion: [fat_r1],
                                color: getNutritionCommentColor(
                                    nutriJsonResponse['Saturated Fat']
                                            ['comment']
                                        .toString()),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getNutritionCommentColor(
                            nutriJsonResponse['Saturated Fat']['comment']
                                .toString()),
                      ),
                    ),
                    title: Text(nutriJsonResponse['Saturated Fat']['comment']
                        .toString()),
                    subtitle: Text(nutriJsonResponse['Saturated Fat']
                            ['percentage']
                        .toString()),
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
            ),
        ],
      );
    }
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: null,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Blue1,
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) {
                  return HomeScreen();
                }),
              ),
            );
          },
        ),
        title: Text(
          "Results",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ingredientsJsonResponse != null)
              buildIngredientsList(ingredientsJsonResponse!, context)
            else
              ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 2, color: Colors.black.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text("Ingredients Information:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("No ingredients found")),
            SizedBox(height: 16.0),
            if (nutriJsonResponse != null)
              buildNutritionList(nutriJsonResponse!, context)
            else
              ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 2, color: Colors.black.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text("Nutritional Information:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("No nutrition table found")),
          ],
        ),
      ),
    );
  }
}
