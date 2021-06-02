import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HachinguPreferences {
  static SharedPreferences prefs;

  static const THEME_STATUS = "THEMESTATUS";
  static const EMAIL_STATUS = "EMAILSTATUS";
  static const NOTIFICATION_STATUS = "NOTIFICATIONSTATUS";
  static const LOCAL_REMINDER_TIME = "LOCALREMINDERTIME";
  static const EMAIL_REMINDER_TIME = "EMAILREMINDERTIME";
  static const USER_EMAIL = "USEREMAIL";

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  setDarkTheme(bool value) async => await prefs.setBool(THEME_STATUS, value);

  setEmails(bool value) async => prefs.setBool(EMAIL_STATUS, value);

  setNotifications(bool value) async => prefs.setBool(NOTIFICATION_STATUS, value);

  setLocalReminder(TimeOfDay time) async {
    final localreminder = time.toString();
    prefs.setString(LOCAL_REMINDER_TIME, localreminder);
  }

  setEmailReminder(TimeOfDay time) async {
    final emailreminder = time.toString();
    prefs.setString(EMAIL_REMINDER_TIME, emailreminder);
  }

  static Future setUserEmail(String user_email) async => await prefs.setString(USER_EMAIL, user_email);

  static String getUserEmail() => prefs.get(USER_EMAIL) ?? "sample@gmail.com";

  Future<bool> getTheme() async {
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  Future<bool> getEmails() async {
    return prefs.getBool(EMAIL_STATUS) ?? false;
  }

  Future<bool> getNotifications() async {
    return prefs.getBool(NOTIFICATION_STATUS) ?? false;
  }

  static TimeOfDay getLocalReminder() {
    final reminder = prefs.getString(LOCAL_REMINDER_TIME);
    if (reminder != null){
      String h = (reminder.split(":")[0]);
      String m = (reminder.split(":")[1]);
      h = (h.split("(")[1]);
      m = (m.split(")")[0]);
      TimeOfDay rem = TimeOfDay(hour:int.parse(h), minute: int.parse(m));
      return rem;
    }
    else{
      return TimeOfDay.now();
    }
  }

  static TimeOfDay getEmailReminder() {
    final reminder = prefs.getString(EMAIL_REMINDER_TIME);
    if (reminder != null){
      String h = (reminder.split(":")[0]);
      String m = (reminder.split(":")[1]);
      h = (h.split("(")[1]);
      m = (m.split(")")[0]);
      TimeOfDay rem = TimeOfDay(hour:int.parse(h), minute: int.parse(m));
      return rem;
    }
    else{
      return TimeOfDay.now();
    }
  }
}