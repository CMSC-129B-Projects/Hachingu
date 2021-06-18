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
  String tip = "";
  var sWidth, sHeight;
  double contheight = 0;
  double contwidth = 0;
  double childrenOpacity = 0;
  String impath = "";

  _TipsPopupState(String tip) {
    this.tip = tip;
    animate(this.tip);
  }

  animate(tip) async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      this.contheight = sHeight * 0.5;
      this.contwidth = sWidth * 0.92;
      this.childrenOpacity = 1.0;
      // this.tip = tip;
    });
    await Future.delayed(Duration(milliseconds: 80));
    setState(() {
      this.impath = 'assets/images/light-bulb.png';
    });
  }

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
              alignment: Alignment.center,
              child: Container(
                width: sWidth * 0.92,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedContainer(
                    curve: Curves.linear,
                    width: this.contwidth,
                    height: this.contheight,
                    duration: Duration(milliseconds: 80),
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
                              // width: sWidth * 0.92,
                              // height: sHeight * 0.5,
                              decoration: BoxDecoration(
                                  color: Color(0xfffAB316),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                  child: Material(
                                    color: Colors.white.withAlpha(0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Opacity(
                                            opacity: 0.8,
                                            child: Center(
                                              child: AnimatedOpacity(
                                                duration:
                                                    Duration(milliseconds: 120),
                                                opacity: this.childrenOpacity,
                                                child: this.impath == ""
                                                    ? SizedBox()
                                                    : Image.asset(
                                                        this.impath,
                                                        width: 80,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Center(
                                            child: AnimatedOpacity(
                                              opacity: this.childrenOpacity,
                                              duration:
                                                  Duration(milliseconds: 150),
                                              child: Text(
                                                this.tip,
                                                overflow: TextOverflow.fade,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    // fontFamily: 'Open Sans',
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
            ),
          ),
        ],
      ),
    );
  }
}
