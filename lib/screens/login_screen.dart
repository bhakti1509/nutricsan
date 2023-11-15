// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nutriscan/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/forget_password.dart';
import 'package:nutriscan/services/firebase_auth_methods.dart';
import 'package:nutriscan/widgets/custom_textFeild.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login-email-password';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: email.text,
          password: password.text,
          context: context,
        );
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.5, 50, 0.5, 0.5),
        child: Column(children: [
          Image(
            image: ExactAssetImage('assets/images/images.png'),
            fit: BoxFit.fill,
            height: 200,
          ),
          Text(
            'Hello again!!',
            style: TextStyle(
              color: Blue1,
              fontWeight: FontWeight.bold,
              fontSize: 45,
            ),
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
            height: 20,
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
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 180),
            child: GestureDetector(
                child: Text('Forgot Password',
                    style: TextStyle(
                      color: Blue1,
                      fontSize: 15,
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return forgotPassword();
                      }),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 30,
            width: double.infinity,
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Blue1,
                    disabledBackgroundColor: Blue1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: loginUser,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
            width: double.infinity,
          ),
        ]),
      ),
    );
  }
}
