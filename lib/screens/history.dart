import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutriscan/screens/apiResponsePage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryItem> _history = [];

  List<HistoryItem> get history => _history;

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getStringList('history');

    if (historyData != null) {
      _history = historyData.map((data) {
        final parts = data.split('|');
        final imageFile = File(parts[0]);
        Map<String, dynamic>? ingredientsJsonResponse;
        Map<String, dynamic>? nutriJsonResponse;

        if (parts.length > 1) {
          ingredientsJsonResponse =
              Map<String, dynamic>.from(json.decode(parts[1]));
        }

        if (parts.length > 2) {
          nutriJsonResponse = Map<String, dynamic>.from(json.decode(parts[2]));
        }

        return HistoryItem(
            imageFile: imageFile,
            ingredientsJsonResponse: ingredientsJsonResponse,
            nutriJsonResponse: nutriJsonResponse);
      }).toList();
      notifyListeners();
    }
  }

  Future<void> addToHistory(HistoryItem item) async {
    _history.add(item);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final historyData = _history.map((item) {
      final imageFilePath = item.imageFile.path;
      final ingredientsJson = item.ingredientsJsonResponse != null
          ? json.encode(item.ingredientsJsonResponse)
          : "";
      final nutriJson = item.nutriJsonResponse != null
          ? json.encode(item.nutriJsonResponse)
          : "";
      return '$imageFilePath|$ingredientsJson|$nutriJson';
    }).toList();
    prefs.setStringList('history', historyData);
  }
}

class HistoryItem {
  final File imageFile;
  final Map<String, dynamic>? ingredientsJsonResponse;
  final Map<String, dynamic>? nutriJsonResponse;
  HistoryItem(
      {required this.imageFile,
      required this.nutriJsonResponse,
      required this.ingredientsJsonResponse});
}

class HistoryItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);

    return ListView.builder(
      itemCount: historyProvider.history.length,
      itemBuilder: (context, index) {
        HistoryItem item = historyProvider.history[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ApiResponsePage(
                      ingredientsJsonResponse: item.ingredientsJsonResponse,
                      nutriJsonResponse: item.nutriJsonResponse)),
            );
          },
          child: ListTile(
            title: Text('Product ${index + 1}'),
            trailing: Image.file(item.imageFile),
          ),
        );
      },
    );
  }
}
