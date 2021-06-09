import 'package:flutter/foundation.dart';
import 'package:hachingu/Utils/preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  HachinguPreferences hachinguPreferences = HachinguPreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    hachinguPreferences.setDarkTheme(value);
    notifyListeners();
  }
}