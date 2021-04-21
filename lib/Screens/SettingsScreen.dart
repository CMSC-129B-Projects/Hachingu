import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            backgroundColor: Colors.amber,
            elevation: 1,
            title: new Text(
              "Settings",
              style: TextStyle(

                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white))),
        body: Container(
            padding: EdgeInsets.only(left: 1, top: 25, right: 1, bottom: 25),
            child: ListView(
              children: [

                buildNotificationOptionRow("Dark Mode", false, 1),
                buildNotificationOptionRow("Receive Emails", true, 2),
                buildNotificationOptionRow("Receive notifications", false, 3),
              ],
            )));
  }

  Container buildNotificationOptionRow(String title, bool isActive, int index) {
    return Container(
      height: 80,
      color: (index%2==0) ? Colors.white : Color(0xfff5edc9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child:
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
               )

          ),

          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child:
            Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: isActive,
                  onChanged: (bool val){

                  },
                  activeColor: Colors.green,
                  activeTrackColor: Colors.lightGreen,
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white12,
                )
            ),
          )
        ],
      ),
    );
  }
}

