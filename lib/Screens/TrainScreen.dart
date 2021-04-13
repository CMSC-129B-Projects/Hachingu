import 'package:flutter/material.dart';

class TrainScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
        body: Container(
            color: Color(0xff01AFE0),
            child: Column(
                children: [
                  Positioned(
                    top: 0,
                    child: Column(
                        children: [
                          Container(
                            width: sWidth,
                            height: sHeight * 0.12,
                          ),
                          Text(
                            "Writing Challenges",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Oswald', color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ]
                    ),

                  ),

                  Stack(

                      children: [
                        InkWell(
                            onTap: () {
                              print("Tapped");
                            },
                            child: Container(
                                height:100,
                                width: 100,
                                child: Text(
                                    "Character"
                                )
                            )
                        ),
                        InkWell(
                            onTap: (){
                              print("Tapped");
                            },
                            child: Container(
                                height: 100,
                                width: 100,
                                child: Text(
                                    "Word"
                                )
                            )
                        )

                      ]
                  )
                ]
            )
        )
    );
  }
}