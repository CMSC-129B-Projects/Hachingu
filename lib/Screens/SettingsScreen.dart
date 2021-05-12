import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Utils/styles.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>{
  var sWidth, sHeight;

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return settingsBody(themeProvider);
  }

  Widget settingsBody(DarkThemeProvider themeProvider){
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 1,
            title: new Text(
              "Settings",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor))),
        body: Container(
            padding: EdgeInsets.only(left: 1, top: 25, right: 1, bottom: 25),
            child: ListView(
              children: [
                /*SwitchListTile(
                    activeColor: Colors.green,
                    activeTrackColor: Colors.lightGreen,
                    inactiveThumbColor: Colors.white70,
                    inactiveTrackColor: Colors.white12,
                    value: themeProvider.darkTheme,
                    title: Text("Dark Mode"),
                    onChanged: (bool value) {
                      themeProvider.darkTheme = value;
                    },
                ),*/
                Container(
                  height: 80,
                  color: Theme.of(context).splashColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child:
                          Text(
                            "Dark Mode",
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
                              value: themeProvider.darkTheme,
                              onChanged: (bool value){
                                themeProvider.darkTheme = value;
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
                ),
                Container(
                  height: 80,
                  color: Theme.of(context).shadowColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child:
                          Text(
                            "Receive Emails",
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
                              value: false,
                              onChanged: (bool value){

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
                ),
                Container(
                  height: 80,
                  color: Theme.of(context).splashColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child:
                          Text(
                            "Receive Notifications",
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
                              value: false,
                              onChanged: (bool value){

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
                ),
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
                  onChanged: (state){
                    setState(() {

                    });
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


/*class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}
class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }
*/