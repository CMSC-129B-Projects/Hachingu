import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:hachingu/Notifiers/notifications_provider.dart';
import 'package:hachingu/Notifiers/email_sender.dart';
import 'package:hachingu/Utils/preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var sWidth, sHeight;
  final _formKey = GlobalKey<FormState>();
  bool showToggles = false;
  TimeOfDay _timeLocal, _timeEmail;
  TimeOfDay pickedLocal, pickedEmail;
  Time converted;
  int _hour, _minute;
  String user_email;

  @override
  void initState() {
    super.initState();
    user_email = HachinguPreferences.getUserEmail();
    _timeLocal = HachinguPreferences.getLocalReminder();
    _timeEmail = HachinguPreferences.getEmailReminder();
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final notificationsProvider = Provider.of<NotificationsProvider>(context);
    final emailProvider = Provider.of<EmailProvider>(context);
    return settingsBody(themeProvider, notificationsProvider, emailProvider);
  }

  Widget settingsBody(
      DarkThemeProvider themeProvider,
      NotificationsProvider notificationsProvider,
      EmailProvider emailProvider) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(10))),
            backgroundColor: Theme.of(context).accentColor,
            elevation: 1,
            title: new Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 30))),
        body: Container(
            padding: EdgeInsets.only(left: 1, top: 25, right: 1, bottom: 25),
            child: ListView(children: [
              Container(
                height: 80,
                color: Theme.of(context).splashColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          "Dark Mode",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
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
              Column(children: [
                Container(
                  height: 80,
                  color: Theme.of(context).shadowColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            "Notifications",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: IconButton(
                            icon: showToggles
                                ? Icon(Icons.keyboard_arrow_up_rounded)
                                : Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 40,
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              setState(() {
                                showToggles = !showToggles;
                              });
                            },
                          ))
                    ],
                  ),
                ),
                showEmailToggle(showToggles, emailProvider),
                showAlertToggle(showToggles, notificationsProvider),
              ]),
            ])));
  }

  Consumer showEmailToggle(bool val, EmailProvider emailProvider) {
    if (val == true) {
      return Consumer<EmailProvider>(
        builder: (context, model, _) => Column(children: [
          Container(
            height: 80,
            color: Theme.of(context).shadowColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Container(
                        margin: const EdgeInsets.only(left: 40.0, right: 20.0),
                        child: Text(
                          "Receive Emails",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
                Flexible(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Transform.scale(
                            scale: 1.2,
                            child: Switch(
                              value: emailProvider.email,
                              onChanged: (bool value) {
                                emailProvider.email = value;
                                value
                                    ? model.EmailNotificationsEnabled(
                                        user_email, pickedEmail)
                                    : value;
                              },
                              activeColor: Colors.green,
                              activeTrackColor: Colors.lightGreen,
                              inactiveThumbColor: Colors.white70,
                              inactiveTrackColor: Colors.white12,
                            ))))
              ],
            ),
          ),
          showEmailAddress(emailProvider.email, user_email),
          showEmailNotificationTime(emailProvider.email),
          //showNotificationTime(emailProvider.email),
        ]),
      );
    } else {
      return Consumer<EmailProvider>(
          builder: (context, model, _) => Container(
                height: 0,
              ));
    }
  }

  Consumer showAlertToggle(
      bool val, NotificationsProvider notificationsProvider) {
    if (val == true) {
      return Consumer<NotificationsProvider>(
        builder: (context, model, _) => Column(children: [
          Container(
            height: 80,
            color: Theme.of(context).shadowColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Flexible(
                Container(
                    margin: const EdgeInsets.only(left: 40.0, right: 20.0),
                    child: Text(
                      "Receive App Alerts",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Flexible(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Transform.scale(
                            scale: 1.2,
                            child: Switch(
                              value: notificationsProvider.notifications,
                              onChanged: (bool value) {
                                notificationsProvider.notifications = value;
                                value
                                    ? model.scheduledNotification(converted)
                                    : model.cancelNotification();
                              },
                              activeColor: Colors.green,
                              activeTrackColor: Colors.lightGreen,
                              inactiveThumbColor: Colors.white70,
                              inactiveTrackColor: Colors.white12,
                            ))))
              ],
            ),
          ),
          showLocalNotificationTime(notificationsProvider.notifications),
        ]),
      );
    } else {
      return Consumer<NotificationsProvider>(
          builder: (context, model, _) => Container(
                height: 0,
              ));
    }
  }

  Container showEmailAddress(bool value, String email) {
    if (value == true) {
      return Container(
        height: 60,
        color: Theme.of(context).shadowColor,
        //child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //children: [
        child: Container(
          child: TextFormField(
            initialValue: email,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email Address',
            ),
            onChanged: (String text) async {
              await HachinguPreferences.setUserEmail(text);
              EmailProvider().EmailNotificationsEnabled(text, pickedEmail);
            },
          ),
        ),
      );
    } else {
      return Container(height: 0);
    }
  }

  Container showEmailNotificationTime(bool value) {
    if (value == true) {
      return Container(
          height: 60,
          color: Theme.of(context).shadowColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                margin: const EdgeInsets.only(left: 50.0, right: 20.0),
                child: Text(
                  "Daily Email",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: FlatButton(
                    onPressed: () {
                      selectEmailTime(context);
                    },
                    child: Text(
                      timeFormatString(_timeEmail),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
          ]));
    } else {
      return Container(height: 0);
    }
  }

  Container showLocalNotificationTime(bool value) {
    if (value == true) {
      return Container(
          height: 60,
          color: Theme.of(context).shadowColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                margin: const EdgeInsets.only(left: 50.0, right: 20.0),
                child: Text(
                  "Daily Reminder",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: FlatButton(
                    onPressed: () {
                      selectLocalTime(context);
                    },
                    child: Text(
                      timeFormatString(_timeLocal),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
          ]));
    } else {
      return Container(height: 0);
    }
  }

  String timeFormatString(TimeOfDay time) {
    String hour, minute, formatted, period;

    hour = time.hour.toString();
    minute = time.minute.toString();
    if (time.minute < 10) {
      minute = '0' + minute;
    }
    if (time.hour == 0) {
      hour = '12';
    }
    if (time.hour >= 12) {
      period = 'PM';
      if (time.hour > 12) {
        int newhour = time.hour - 12;
        hour = newhour.toString();
      }
    } else {
      period = 'AM';
    }
    formatted = hour + ":" + minute + " " + period;
    return formatted;
  }

  Future<Null> selectLocalTime(BuildContext context) async {
    final TimeOfDay pickedLocal = await showTimePicker(
      context: context,
      initialTime: _timeLocal,
    );
    if (pickedLocal != null) {
      setState(() {
        _timeLocal = pickedLocal;
        _hour = _timeLocal.hour;
        _minute = _timeLocal.minute;
        converted = Time(_hour, _minute, 0);
        HachinguPreferences().setLocalReminder(_timeLocal);
        NotificationsProvider().scheduledNotification(converted);
      });
    }
  }

  Future<Null> selectEmailTime(BuildContext context) async {
    final TimeOfDay pickedEmail = await showTimePicker(
      context: context,
      initialTime: _timeEmail,
    );
    if (pickedEmail != null) {
      setState(() {
        _timeEmail = pickedEmail;
        HachinguPreferences().setEmailReminder(_timeEmail);
        EmailProvider().EmailNotificationsEnabled(user_email, _timeEmail);
      });
    }
  }
}
