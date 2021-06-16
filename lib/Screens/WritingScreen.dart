import 'dart:convert';
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
import 'package:flutter/services.dart' show rootBundle;

class WritingScreen extends StatefulWidget {
  @override
  final String title;

  const WritingScreen(this.title);
  _WritingScreenState createState() => _WritingScreenState();
}

class _WritingScreenState extends State<WritingScreen> {
  var sWidth, sHeight;
  List _items = [
    {
      "question": "Loading...",
      "answer": "Loading...",
      "choices": ["Loading...", "Loading...", "Loading...", "Loading..."]
    }
  ];
  int indx = 0;

  Classifier _classifier;
  Category category = Category("", 0);

  bool _finished = false;
  PainterController _controller = _newController();

  Uint8List test_image;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant(numThreads: 1, modelType: "syllable");
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle
        .loadString('assets/challenges/' + widget.title + '.json');
    final data = await json.decode(response);
    setState(() {
      _items = data..shuffle();
      _items = _items.sublist(0, 11);
    });
  }

  static PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 16.0;
    controller.backgroundColor = Colors.white;
    // controller.
    // controller.backgroundColor = Color(0xfffcedbf);

    return controller;
  }

  void _predict(Uint8List imgg) async {
    img.Image imageInput = img.decodeImage(imgg);
    var pred = _classifier.predict(imageInput);

    test_image = await _classifier.process_debug_image(imageInput);
    setState(() {
      this.category = pred;
    });
    print(category.label);
    print(category.score);
  }

  void _show(PictureDetails picture) async {
    setState(() {
      _finished = true;
    });
    _predict((await picture.toPNG()));

    _controller = _newController();
    setState(() {
      // _items[indx]["hangul"] = description;
      indx++;
      if (indx == 10) {
        print("osho bayot");
      }
    });
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
                        TextStyle(fontSize: 36, fontWeight: FontWeight.w600)),
                Text(_items[indx]["roman"].toString(),
                    style:
                        TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
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
                        () => _show(_controller.finish())),
                  ]),
              Container(
                height: 360,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: new Painter(_controller)),
              ),
              Text(
                  indx - 1 >= 0
                      ? "real: " + _items[indx - 1]["hangul"].toString()
                      : "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
              Text(
                  this.category.label != null
                      ? "pred: " + this.category.label
                      : "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
              Text(
                  this.category.score.toString() != null
                      ? this.category.score.toString()
                      : "",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200)),
              // test_image != null ? Image.memory(test_image) : SizedBox()
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