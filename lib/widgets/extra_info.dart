import 'package:flutter/material.dart';
import 'package:nutriscan/components/constants.dart';

class info extends StatelessWidget {
  String title;
  List<String> information;
  List<String> recommenadtion;
  String r_title;
  Color color;

  info(
      {required this.title,
      required this.information,
      required this.r_title,
      required this.recommenadtion,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Blue1,
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: ListTile(
          tileColor: Blue2,
          // leading: Container(
          //   height: 40,
          //   alignment: Alignment.topLeft,
          //   width: 40,
          //   decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          // ),
          // title: Text(
          //   title,
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          title: Column(
            children: [
              ListTile(
                title:
                    Text(what, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  children: information.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                title: Text(r_title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  children: recommenadtion.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
