import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hachingu/ScopedModels/AppModel.dart';
import 'package:hachingu/Screens/SettingsScreen.dart';
import 'package:hachingu/Screens/LearnScreen.dart';
import 'package:hachingu/Screens/TrainScreen.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController learnCardControllerRotate;
  AnimationController trainCardControllerRotate;
  AnimationController learnCardControllerTransform;
  AnimationController trainCardControllerTransform;

  double learnCardPosx = 0;
  double trainCardPosx = 0;

  double learnCardAngle = 0;
  double trainCardAngle = 0;
  var sWidth, sHeight;
  var currentFocus = "learn";

  @override
  void initState() {
    learnCardPosx = 0;
    trainCardPosx = 0;

    learnCardAngle = 0;
    trainCardAngle = 0;
    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    learnCardControllerRotate = AnimationController(
        duration: Duration(milliseconds: 140),
        vsync: this,
        lowerBound: 0,
        upperBound: 30);
    learnCardControllerRotate.addListener(() {
      if (learnCardControllerRotate.isCompleted) {
        learnCardControllerRotate.reverse();
      }
      setState(() {
        learnCardAngle = learnCardControllerRotate.value;
      });
    });

    learnCardControllerTransform = AnimationController(
        duration: Duration(milliseconds: 140),
        vsync: this,
        lowerBound: 0,
        upperBound: 100);
    learnCardControllerTransform.addListener(() {
      if (learnCardControllerTransform.isCompleted) {
        learnCardControllerTransform.reverse();
      }
      setState(() {
        learnCardPosx = learnCardControllerTransform.value;
      });
    });

    trainCardControllerRotate = AnimationController(
        duration: Duration(milliseconds: 140),
        vsync: this,
        lowerBound: 0,
        upperBound: 30);

    trainCardControllerRotate.addListener(() {
      if (trainCardControllerRotate.isCompleted) {
        trainCardControllerRotate.reverse();
      }

      setState(() {
        trainCardAngle = trainCardControllerRotate.value;
      });
    });

    trainCardControllerTransform = AnimationController(
        duration: Duration(milliseconds: 140),
        vsync: this,
        lowerBound: 0,
        upperBound: 100);

    trainCardControllerTransform.addListener(() {
      if (trainCardControllerTransform.isCompleted) {
        trainCardControllerTransform.reverse();
      }

      setState(() {
        trainCardPosx = trainCardControllerTransform.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  hover() {}
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return HomeBody(themeProvider);
  }

  Widget HomeBody(DarkThemeProvider themeProvider) {
    List<Widget> stackChildren = [
      Positioned(
        left: 20 - trainCardPosx,
        top: 85,
        child: Transform.rotate(
          angle: -1.2 * trainCardAngle * math.pi / 180,
          child: new InkWell(
            onLongPress: () async {
              if (currentFocus != "write") {
                learnCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                learnCardControllerTransform.animateTo(
                    learnCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                trainCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                trainCardControllerTransform.animateTo(
                    trainCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                await Future.delayed(Duration(milliseconds: 150));
                setState(() {
                  currentFocus = "write";
                });
              }
            },
            onTap: () async {
              if (currentFocus != "write") {
                learnCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                learnCardControllerTransform.animateTo(
                    learnCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                trainCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                trainCardControllerTransform.animateTo(
                    trainCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                await Future.delayed(Duration(milliseconds: 150));
                setState(() {
                  currentFocus = "write";
                });
              }
              await Future.delayed(Duration(milliseconds: 200));

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TrainScreen()));
            },
            child: Container(
              width: sWidth / 2,
              height: sHeight * 0.34,
              decoration: BoxDecoration(
                  color: Color(0xff01AFE0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3.0),
                        color: Colors.grey[400]),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(26))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/writing_hand.png",
                    width: 105,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Train",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
          right: 20 - this.learnCardPosx,
          bottom: 40,
          child: Transform.rotate(
            angle: 1.2 * learnCardAngle * math.pi / 180,
            child: new InkWell(
              onLongPress: () async {
                if (currentFocus != "learn") {
                  learnCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  learnCardControllerTransform.animateTo(
                      learnCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  trainCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  trainCardControllerTransform.animateTo(
                      trainCardControllerTransform.upperBound,
                      curve: Curves.easeIn);

                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() {
                    currentFocus = "learn";
                  });
                }
              },
              onTap: () async {
                if (currentFocus != "learn") {
                  learnCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  learnCardControllerTransform.animateTo(
                      learnCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  trainCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  trainCardControllerTransform.animateTo(
                      trainCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() {
                    currentFocus = "learn";
                  });
                }

                await Future.delayed(Duration(milliseconds: 200));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LearnScreen()));
              },
              child: Container(
                height: sHeight * 0.34,
                width: sWidth / 2,
                decoration: BoxDecoration(
                  color: Color(0xffF34F4E),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3.0),
                        color: Colors.grey[400]),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/read_aloud.png",
                      width: 155,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Learn",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Open Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ))
    ];
    List<Widget> stackChildren2 = [
      Positioned(
          right: 20 - learnCardPosx,
          bottom: 40,
          child: Transform.rotate(
            angle: 1.2 * learnCardAngle * math.pi / 180,
            child: new InkWell(
              onLongPress: () async {
                if (currentFocus != "learn") {
                  learnCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  learnCardControllerTransform.animateTo(
                      learnCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  trainCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  trainCardControllerTransform.animateTo(
                      trainCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() {
                    currentFocus = "learn";
                  });
                }
              },
              onTap: () async {
                if (currentFocus != "learn") {
                  learnCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  learnCardControllerTransform.animateTo(
                      learnCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  trainCardControllerRotate.animateTo(
                      learnCardControllerRotate.upperBound,
                      curve: Curves.easeIn);

                  trainCardControllerTransform.animateTo(
                      trainCardControllerTransform.upperBound,
                      curve: Curves.easeIn);
                  await Future.delayed(Duration(milliseconds: 150));
                  setState(() {
                    currentFocus = "learn";
                  });
                }
                await Future.delayed(Duration(milliseconds: 200));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LearnScreen()));
              },
              child: Container(
                height: sHeight * 0.34,
                width: sWidth / 2,
                decoration: BoxDecoration(
                  color: Color(0xffF34F4E),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3.0),
                        color: Colors.grey[400]),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/read_aloud.png",
                      width: 155,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Learn",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Open Sans',
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          )),
      Positioned(
        left: 20 - trainCardPosx,
        top: 85,
        child: Transform.rotate(
          angle: -1.2 * trainCardAngle * math.pi / 180,
          child: new InkWell(
            onLongPress: () async {
              if (currentFocus != "write") {
                learnCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                learnCardControllerTransform.animateTo(
                    learnCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                trainCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                trainCardControllerTransform.animateTo(
                    trainCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                await Future.delayed(Duration(milliseconds: 150));
                setState(() {
                  currentFocus = "write";
                });
              }
            },
            onTap: () async {
              if (currentFocus != "write") {
                learnCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                learnCardControllerTransform.animateTo(
                    learnCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                trainCardControllerRotate.animateTo(
                    learnCardControllerRotate.upperBound,
                    curve: Curves.easeIn);

                trainCardControllerTransform.animateTo(
                    trainCardControllerTransform.upperBound,
                    curve: Curves.easeIn);
                await Future.delayed(Duration(milliseconds: 150));
                setState(() {
                  currentFocus = "write";
                });
              }

              await Future.delayed(Duration(milliseconds: 200));
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => TrainScreen()));
            },
            child: Container(
              width: sWidth / 2,
              height: sHeight * 0.34,
              decoration: BoxDecoration(
                  color: Color(0xff01AFE0),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5.0,
                        offset: Offset(0.0, 3.0),
                        color: Colors.grey[400]),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(26))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/writing_hand.png",
                    width: 105,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text("Train",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    return ScopedModel<AppModel>(
        model: AppModel(),
        child:
        ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          return Scaffold(
            body: Container(
              color: Theme.of(context).backgroundColor,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Column(
                      children: [
                        Container(
                          width: sWidth,
                          height: sHeight * 0.12,
                        ),
                        Text.rich(TextSpan(
                            text: "   Learn Korean\n with",
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                              // letterSpacing: 0.7,
                              color: Theme.of(context).primaryColor,
                              fontSize: 40,
                            ),
                            children: <InlineSpan>[
                              TextSpan(
                                  text: " Hachingu!",
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w700,
                                    // letterSpacing: 0.6,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 40,
                                  ))
                            ])),

                        Container(
                          width: sWidth,
                          height: sHeight * 0.66,
                          child: Stack(
                            children: this.currentFocus == "write" ? stackChildren2 : stackChildren,
                          ),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      splashColor: Color(0xffFFEDBF),
                      focusColor: Colors.white.withAlpha(0),
                      highlightColor: Color(0xffFFEDBF),
                      height: 77,
                      minWidth: 77,
                      color: Color(0xfffAB316),
                      onPressed: () async {
                        await Future.delayed(Duration(milliseconds: 200));
                        _controller.reset();
                        _controller.forward();
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SettingsScreen()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(38),
                              topRight: Radius.circular(38),
                              bottomRight: Radius.circular(42))),
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                        child: Image.asset(
                          'assets/images/cog.png',
                          width: 38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
