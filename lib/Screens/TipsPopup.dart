import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class TipsPopup extends StatefulWidget {
  String tip;
  BuildContext context;
  TipsPopup(this.tip);
  @override
  _TipsPopupState createState() => _TipsPopupState(this.tip);
}

class _TipsPopupState extends State<TipsPopup> {
  String tip;

  _TipsPopupState(this.tip);
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return TipsPopupbody(themeProvider);
  }

  Widget TipsPopupbody(DarkThemeProvider themeProvider) {
    return Container(
      width: sWidth,
      height: sHeight,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 30,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: sWidth * 0.92,
                height: sHeight * 0.35,
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 50,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(30)),
                            color: Color(0xfffAB316),
                          ),
                        )),
                    Positioned.fill(
                      bottom: 30,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: sWidth * 0.92,
                          height: sHeight * 0.35,
                          decoration: BoxDecoration(
                              color: Color(0xfffAB316),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Material(
                                color: Colors.white.withAlpha(0),
                                child: Text(
                                  this.tip,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      // fontFamily: 'Open Sans',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
