import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:hachingu/ScopedModels/AppModel.dart';
import 'package:hachingu/Screens/SettingsScreen.dart';
import 'package:hachingu/Screens/LearnScreen.dart';
import 'package:hachingu/Screens/TrainScreen.dart';

class HomeScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return ScopedModel<AppModel>(
        model: AppModel(),
        child:
            ScopedModelDescendant<AppModel>(builder: (context, child, model) {
          return Scaffold(
            body: Container(
              color: Colors.white,
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
                        Text(" Learn Korean\nwith Hachingu",
                            style:
                                TextStyle(fontFamily: 'Oswald Bold', color: Colors.black, fontSize: 40, )),
                        Container(
                          width: sWidth,
                          height: sHeight * 0.66,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                top: 85,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            TrainScreen()));
                                  },
                                  child: Container(
                                  width: sWidth / 2,
                                  height: sHeight * 0.34,
                                  decoration: BoxDecoration(
                                      color: Color(0xff01AFE0),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 8.0,
                                            offset: Offset(-3.0, 3.0),
                                            color: Colors.grey),
                                      ],
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(26))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/images/write.PNG",
                                        width: 105,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text("Train",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),),
                              Positioned(
                                right: 20,
                                bottom: 40,
                                child: new InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LearnScreen()));
                                  },
                                  child: Container(
                                    height:sHeight * 0.34,
                                    width: sWidth / 2,

                                    decoration: BoxDecoration(
                                      color: Color(0xffF34F4E),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 8.0,
                                              offset: Offset(-3.0, 3.0),
                                              color: Colors.grey),
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(26)),
                                    ),

                                // child: Container(
                                //   width: sWidth / 2,
                                //   height: sHeight * 0.34,
                                //   decoration: BoxDecoration(
                                //       color: Color(0xffF34F4E),
                                //       boxShadow: [
                                //         BoxShadow(
                                //             blurRadius: 8.0,
                                //             offset: Offset(-3.0, 3.0),
                                //             color: Colors.grey),
                                //       ],
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(26))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [
                                      Image.asset(
                                        "assets/images/learn.PNG",
                                        width: 155,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("Learn",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              )
                              )],
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
                      height: 85,
                      color: Color(0xfffAB316),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SettingsScreen()));
                        // Fluttertoast.showToast(msg: "Hellow");
                        // model.increment();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(33),
                              bottomLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomRight: Radius.circular(45))),
                      child: Icon(
                        Icons.settings,
                        size: 45,
                        color: Colors.white,
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
