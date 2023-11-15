// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  CustomCard({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  
                  style: TextStyle(
            color: Blue1,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
                ),
              ),
              SizedBox(height: 8),
            
            
            ],
          ),
        ),
      ),
    );
  }
}
