// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:flutter/material.dart';

import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/services/firebase_auth_methods.dart';
import 'package:nutriscan/widgets/custom_textFeild.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  static String routeName = '/signup-email-password';
  SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
    void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: email.text,
          password: password.text,
          context: context,
        );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        
        child: Padding(
          padding: const EdgeInsets.only(top: 94),
          child: Column(
            children: [
                   Image(
          image: ExactAssetImage('assets/images/images.png'),
          fit: BoxFit.fill,
          height: 200,
        ),
           SizedBox(
          height: 10,
          width: double.infinity,
        ),
                Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                
                child: CustomTextField(
                  controller: email,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.account_circle,
                    color: Blue1,
                  ),
                )),
                   SizedBox(
          height: 10,
          width: double.infinity,
        ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: CustomTextField(
                    controller: password,
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Blue1,
                    ))),
           
            
                SizedBox(
              height: 60,
              width: double.infinity,
            ),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: ElevatedButton(
                  
                    style: ElevatedButton.styleFrom(
                      
                        backgroundColor: Blue1,
                        disabledBackgroundColor: Blue1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: signUpUser,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                      
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
