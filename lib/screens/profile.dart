// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nutriscan/screens/history.dart';
import 'package:provider/provider.dart';
import 'package:nutriscan/screens/your_prefrence.dart';
import 'package:nutriscan/services/firebase_auth_methods.dart';
import 'package:nutriscan/widgets/custom_card.dart';

class profile extends StatelessWidget {
  const profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(.5),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: double.infinity,
            ),
            Image(
              image: ExactAssetImage('assets/images/images.png'),
              fit: BoxFit.fill,
              height: 200,
            ),
            SizedBox(
              height: 100,
              width: double.infinity,
            ),
            CustomCard(
                title: 'Your prefrenceces',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return Preferences();
                      }),
                    ),
                  );
                }),
            // CustomCard(
            //     title: "History",
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: ((context) {
            //             return HistoryItemWidget();
            //           }),
            //         ),
            //       );
            //     }),
            CustomCard(
                title: "sign out",
                onTap: () {
                  context.read<FirebaseAuthMethods>().signOut(context);
                }),
            CustomCard(
                title: "delete Account",
                onTap: () {
                  context.read<FirebaseAuthMethods>().deleteAccount(context);
                })
          ],
        ));
  }
}
