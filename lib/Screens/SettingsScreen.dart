import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Notifiers/notifications_provider.dart';
import 'package:hachingu/Notifiers/email_sender.dart';
import 'package:hachingu/main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var sWidth, sHeight;
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() {
        _time = picked;
      });
    }
  }
  

  @override
  //void initState(){
  //  Provider.of<NotificationsProvider>(context, listen: false).initialize();
  //}
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    final emailProvider = Provider.of<EmailProvider>(context);
    return settingsBody(themeProvider, notificationsProvider, emailProvider);
  }

  Widget settingsBody(DarkThemeProvider themeProvider, NotificationsProvider notificationsProvider, EmailProvider emailProvider){
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Theme.of(context).accentColor,
            elevation: 1,
            title: new Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back,
                    color: Colors.white, size: 30)
            )
        ),
        body: Container(
            padding: EdgeInsets.only(left: 1, top: 25, right: 1, bottom: 25),
            child: ListView(
                children: [
                  Container(
                    height: 80,
                    color: Theme.of(context).splashColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Text(
                              "Dark Mode",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0),
                          child: Transform.scale(
                              scale: 1.2,
                              child: Switch(
                                value: themeProvider.darkTheme,
                                onChanged: (bool value) {
                                  themeProvider.darkTheme = value;
                                },
                                activeColor: Colors.green,
                                activeTrackColor: Colors.lightGreen,
                                inactiveThumbColor: Colors.white70,
                                inactiveTrackColor: Colors.white12,
                              )),
                        )
                      ],
                    ),
                  ),
                  Consumer<EmailProvider>(
                    builder: (context, model, _) =>
                        Container(
                          height: 80,
                          color: Theme
                              .of(context)
                              .shadowColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin:
                                  const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Text(
                                    "Receive Emails",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Transform.scale(
                                    scale: 1.2,
                                    child: Switch(
                                      value: emailProvider.email,
                                      onChanged: (bool value) {
                                        emailProvider.email = value;
                                        value ? model.EmailNotificationsEnabled() : model.EmailNotificationsDisabled();
                                      },
                                      activeColor: Colors.green,
                                      activeTrackColor: Colors.lightGreen,
                                      inactiveThumbColor: Colors.white70,
                                      inactiveTrackColor: Colors.white12,
                                    )),
                              )
                            ],
                          ),
                        ),
                  ),
                  Consumer<NotificationsProvider>(
                    builder: (context, model, _) =>
                        Column(
                          children: [
                            Container(
                              height: 80,
                              color: Theme.of(context).splashColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      margin:
                                      const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Text(
                                        "Receive Notifications",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Transform.scale(
                                          scale: 1.2,
                                          child: Switch(
                                            value: notificationsProvider.notifications,
                                            onChanged: (bool value) {
                                              notificationsProvider.notifications = value;
                                              value ? value : model.cancelNotification();
                                            },
                                            activeColor: Colors.green,
                                            activeTrackColor: Colors.lightGreen,
                                            inactiveThumbColor: Colors.white70,
                                            inactiveTrackColor: Colors.white12,
                                          )
                                      )
                                  )
                                ],
                              ),
                            ),
                          showNotificationTime(notificationsProvider.notifications),
                    ]
                  ),
            )
        ])
    ));
  }

  Container showNotificationTime(bool value) {
    if (value == true) {
      return Container(
          height: 60,
          color: Theme.of(context).splashColor,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text(
                    "${_time.hour}:${_time.minute}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  IconButton(
                      icon: Icon(Icons.alarm),
                      iconSize: 40,
                      onPressed: () {
                        selectTime(context);
                      },
                  ),
              ]
          )
      );
    }
    else{
      return Container(
        height: 0
      );
    }
  }

  Container buildNotificationOptionRow(String title, bool isActive, int index) {
    return Container(
      height: 80,
      color: (index % 2 == 0) ? Colors.white : Color(0xfff5edc9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: isActive,
                  onChanged: (state) {

                  },
                  activeColor: Colors.green,
                  activeTrackColor: Colors.lightGreen,
                  inactiveThumbColor: Colors.white70,
                  inactiveTrackColor: Colors.white12,
                )),
          )
        ],
      ),
    );
  }


  void scheduleAlarm() async {
    //if (value == true) {
      var scheduleNotificationDateTime =
          DateTime.now().add(Duration(seconds: 10));

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        'Channel for Alarm notification',
        icon: 'hacingu_logo',
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
        largeIcon: DrawableResourceAndroidBitmap('hachingu_logo'),
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'a_long_cold_sting',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          0,
          'Office',
          'Good Morning!',
          scheduleNotificationDateTime,
          platformChannelSpecifics);
    //}
  }
}
