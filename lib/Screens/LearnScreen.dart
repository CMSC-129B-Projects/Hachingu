import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  var sWidth, sHeight;
  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
      body: Container(
        color: Color(0xffF34F4E),
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
                    "Lessons",
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
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Lesson 1"
                    )
                  )
              ),
              InkWell(
                onTap: (){
                  print("Tapped");
                },
                child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        "Lesson 2"
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