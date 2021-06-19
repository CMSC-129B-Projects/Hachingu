import 'package:flutter/material.dart';
import 'Screens/HomeScreen.dart';

void main() {
  runApp(Hachingu());
}

class Hachingu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
