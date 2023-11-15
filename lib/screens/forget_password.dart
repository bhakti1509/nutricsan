// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/widgets/custom_textFeild.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);
  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
            image: ExactAssetImage('assets/images/ForgetPassword.png',
                scale: 0.5)),
                Text('Forget password?'),
                Text('Enter your email below to reset your password.'),
                CustomTextField(
             hintText:'Email address ',
             prefixIcon: Icon(Icons.email,color: Blue1,),
             controller: email,

              ),
      ],
    );
  }
}