//  prefer_const_constructors_in_immutables

// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  CustomTextButton({super.key, 
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      width: MediaQuery.of(context).size.width,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Rectangle edges
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor, // Text color
            fontSize: 20, // Adjust as needed
          ),
        ),
      ),
    );
  }
}