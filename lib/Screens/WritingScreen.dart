import 'package:flutter/material.dart';
import 'package:hachingu/Notifiers/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import '../Utils/classifier.dart';
import '../Utils/classifier_quant.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:painter/painter.dart';
import 'dart:typed_data';

class WritingScreen extends StatefulWidget {
  @override
  _WritingScreenState createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  var sWidth, sHeight;

  Classifier _classifier;
  Category category;

  bool _finished = false;
  PainterController _controller = _newController();

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant(numThreads: 1, modelType: "character");
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 16.0;
    controller.backgroundColor = Color(0xfffcedbf);
    return controller;
  }

  void _predict(imgg) async {
    img.Image imageInput = img.decodeImage(imgg);
    var pred = _classifier.predict(imageInput);

    setState(() {
      this.category = pred;
    });
    print(category.label);
    print("sulod here");
  }

  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: const Text('View your image'),
        ),
        body: new Container(
            alignment: Alignment.center,
            child: new FutureBuilder<Uint8List>(
              future: picture.toPNG(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      // print(snapshot.data.toString());
                      _predict(snapshot.data);
                      return Image.memory(snapshot.data);
                    }
                    break;
                  default:
                    return new Container(
                        child: new FractionallySizedBox(
                      widthFactor: 0.1,
                      child: new AspectRatio(
                          aspectRatio: 1.0,
                          child: new CircularProgressIndicator()),
                      alignment: Alignment.center,
                    ));
                }
              },
            )),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    return HomeBody(themeProvider);
  }

  Widget HomeBody(DarkThemeProvider themeProvider) {
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.amber)),
            backgroundColor: Theme.of(context).backgroundColor),
        body: Container(
            padding: EdgeInsets.all(24),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Text("Write: ",
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                Text("ㅎ",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold))
              ]),
              Container(height: 28),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      ActionBtn(
                          Icons.delete, Color(0xffF34F4E), _controller.clear),
                      ActionBtn(Icons.undo, Color(0xfffab316), () {
                        if (!_controller.isEmpty) {
                          _controller.undo();
                        }
                      })
                    ]),
                    ActionBtn(Icons.arrow_forward, Color(0xff47be02),
                        () => _show(_controller.finish(), context)),
                  ]),
              Container(
                height: 360,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: new Painter(_controller)),
              )
            ])));
  }
}

class ActionBtn extends StatelessWidget {
  final IconData ico;
  final Color colr;
  final Function func;

  const ActionBtn(this.ico, this.colr, this.func);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: func,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              highlightColor: colr.withOpacity(0.6),
              child: Container(
                alignment: Alignment.center,
                child: Icon(ico, color: Colors.white),
              ))),
      margin: EdgeInsets.all(4),
      height: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.1,
      decoration: BoxDecoration(
        color: colr,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
