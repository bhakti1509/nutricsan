// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';

class DetailsAdditives extends StatelessWidget {
  final String code;
  final String name;
  final String purpose;
  final String content;
  final String status;

  DetailsAdditives(
      this.code, this.name, this.purpose, this.content, this.status);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Blue1,
      ),
      body: ListView(
        children: [
          _buildInfoRow("Code", code),
          _buildInfoRow("Name", name),
          _buildInfoRow("Purpose", purpose),
          _buildInfoRow("Description", content),
          _buildInfoRow("Status", status),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String key, String value) {
    return ListTile(
      title: Table(
        columnWidths: {
          0: IntrinsicColumnWidth(flex: 1.0),
          1: IntrinsicColumnWidth(flex: 3.0),
        },
        children: [
          TableRow(
            children: [
              TableCell(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    key + ":",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
