// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/login_options.dart';
class GetStarted extends StatelessWidget {  
   final pages = [
    PageViewModel(
      title: Text('Welcome to Nutri Scan',style: TextStyle(
            color: Blue1,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
       ),
      body: Text('Scan, Score, Savor!\n Elevate your health with every bite!',style: TextStyle(
            color: Blue1,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
       ),
      mainImage:Image.asset('assets/images/food-safety.png') ),

    PageViewModel(
      title: Text("your guide to safe food",style: TextStyle(
            color: Blue1,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
       ),
      mainImage: Image.asset('assets/images/get_started.png'),
      body: Text('Decode Nutrition at a Glance',style: TextStyle(
            color: Blue1,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
       ),)
  
    // Add more pages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Blue2,
        height: MediaQuery.of(context).size.height*0.5,
        width: MediaQuery.of(context).size.width*0.5,
        child: IntroViewsFlutter(
          pages,
          showNextButton: true,
          showSkipButton: false,
        
          pageButtonsColor: Blue1,
          onTapDoneButton: () {
            Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) {
                            return loginOption();
                          }),
                        ),
                      );
                  
            // Handle the action when the user taps the "Done" button
            // For example, navigate to the home screen
          
          },
        ),
      ),
    );
  }
}
 