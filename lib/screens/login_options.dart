// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutriscan/components/constants.dart';
import 'dart:ui' as ui;

import 'package:nutriscan/screens/login_screen.dart';
import 'package:nutriscan/screens/signup_form.dart';
import 'package:nutriscan/services/firebase_auth_methods.dart';
import 'package:nutriscan/widgets/custom_button.dart';

class loginOption extends StatelessWidget {
  const loginOption
({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.5, 50, 0.5, 0.5),
       child: Stack(
        children: [
          // Background Image
          ImageFiltered(
             imageFilter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Image.asset(
              'assets/images/backgroud.png',
              fit: BoxFit.cover,
              
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Overlaying Buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextButton(text: 'Login', backgroundColor: Blue1, textColor: Blue2, 
                onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return LoginScreen();
                          }),
                        ),
                      );
                  
                  },),
                
                SizedBox(height: 20),
                CustomTextButton(text: 'Sign in', backgroundColor: Blue1, textColor: Blue2, 
                onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return SignupForm();
                          }),
                        ),
                      );
                  
                  },),
                SizedBox(height: 20),
                  CustomTextButton(text: 'continue with google', backgroundColor: Blue1, textColor: Blue2, 
                  
                onPressed: () {
                   context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                }
                ),
              ],
            ),
          ),
        ],
      ),  ),
    );
 
  }
}