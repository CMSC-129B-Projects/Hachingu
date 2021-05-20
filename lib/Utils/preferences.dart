import 'package:shared_preferences/shared_preferences.dart';

class HachinguPreferences {
  static const THEME_STATUS = "THEMESTATUS";
  static const EMAIL_STATUS = "EMAILSTATUS";
  static const NOTIFICATION_STATUS = "NOTIFICATIONSTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  setEmails(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(EMAIL_STATUS, value);
  }

  setNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NOTIFICATION_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }

  Future<bool> getEmails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(EMAIL_STATUS) ?? false;
  }

  Future<bool> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(NOTIFICATION_STATUS) ?? false;
  }
}