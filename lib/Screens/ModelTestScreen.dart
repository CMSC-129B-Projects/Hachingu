import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Utils/classifier.dart';
import '../Utils/classifier_quant.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ModelTestScreen extends StatefulWidget {
  ModelTestScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ModelTestScreenState createState() => _ModelTestScreenState();
}

class _ModelTestScreenState extends State<ModelTestScreen> {
  Classifier _classifier;

  var logger = Logger();

  File _image;
  final picker = ImagePicker();

  Image _imageWidget;

  img.Image fox;
  Category category;
  String modelType = "character";

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant(numThreads: 1, modelType: "character");
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      _imageWidget = Image.file(_image);

      _predict();
    });
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image.readAsBytesSync());
    var pred = _classifier.predict(imageInput);

    setState(() {
      this.category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TfLite Flutter Helper',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Text("$modelType",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          MaterialButton(
              color: Colors.red,
              child: Text(
                  '${modelType == "character" ? "syllable" : "character"}'),
              onPressed: () {
                if (modelType == "character")
                  modelType = "syllable";
                else
                  modelType = "character";
                setState(() {});

                _classifier =
                    ClassifierQuant(numThreads: 1, modelType: modelType);
              }),
          Center(
            child: _image == null
                ? Text('No image selected.')
                : Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 2),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: _imageWidget,
                  ),
          ),
          SizedBox(
            height: 36,
          ),
          Text(
            category != null ? category.label : '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            category != null
                ? 'Confidence: ${category.score.toStringAsFixed(3)}'
                : '',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
