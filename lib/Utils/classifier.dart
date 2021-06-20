import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

abstract class Classifier {
  Interpreter interpreter;
  InterpreterOptions _interpreterOptions;

  var logger = Logger();

  List<int> _inputShape;
  List<int> _outputShape;

  TensorImage _inputImage;
  TensorBuffer _outputBuffer;

  TfLiteType _outputType = TfLiteType.uint8;

  String _labelsFileName = 'assets/model-labels/syllable-labels.txt';

  int _labelsLength = 30;

  var _probabilityProcessor;

  List<String> labels;

  String modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int numThreads, String modelType}) {
    String labelsDir;
    int labelsLength = 0;

    if (modelType == "character") {
      modelName = 'tflite-models/character-model.tflite';
      labelsDir = 'assets/model-labels/character-labels.txt';
      labelsLength = 30;
      print("character");
      print(modelName);
    } else if (modelType == "syllable") {
      modelName = 'tflite-models/syllable-model28620-2.tflite';
      labelsDir = 'assets/model-labels/syllable-labels.txt';
      labelsLength = 2350;
      print("syllable");
    }

    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    _labelsLength = labelsLength;
    _labelsFileName = labelsDir;

    loadModel();
    loadLabels();
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      print('Interpreter Created Successfully');

      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _outputType = interpreter.getOutputTensor(0).type;

      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  Future<void> loadLabels() async {
    labels = await FileUtil.loadLabels(_labelsFileName);
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    print(cropSize);
    return ImageProcessorBuilder()
        // .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(_inputShape[1], _inputShape[2], ResizeMethod.BILINEAR))
        // .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Float32List rgb2grayf(List<int> image) {
    Float32List gray_image = Float32List(_inputShape[1] * _inputShape[2]);

    for (int i = 0; i < gray_image.length; i += 1) {
      gray_image[i] =
          ((image[i * 3] + image[(i * 3) + 1] + image[(i * 3) + 2]) /
              (3 * 255));
    }
    // for (int i = 0; i < gray_image.length; i += 1) {
    //   gray_image[i] = ((image[i * 3] * 0.3 +
    //           image[(i * 3) + 1] * 0.59 +
    //           image[(i * 3) + 2] * 0.11) /
    //       (255));
    // }
    // print("grayed");
    // print(gray_image);

    return gray_image;
  }

  List<int> gray2rgb(Float32List gray_image) {
    List<int> rgb_image = Int8List(_inputShape[1] * _inputShape[2] * 3);

    for (int i = 0; i < gray_image.length; i += 1) {
      rgb_image[i * 3] = 255 * gray_image[i] / 3 as int;
      rgb_image[1 + (i * 3)] = 255 * gray_image[i] / 3 as int;
      rgb_image[2 + (i * 3)] = 255 * gray_image[i] / 3 as int;
    }

    return rgb_image;
  }

  Category predict(Image image) {
    if (interpreter == null) {
      throw StateError('Cannot run inference, Intrepreter is null');
    }
    image = grayscale(image);
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage.fromImage(image);
    _inputImage = _preProcess();

    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms ');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(
        rgb2grayf(_inputImage.tensorBuffer.buffer.asUint8List())
            .buffer
            .asFloat32List()
            .reshape([1, _inputShape[1], _inputShape[2], 1]),
        _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);
    var maxi = argmax(_outputBuffer.buffer.asFloat32List());
    return Category(labels[maxi], _outputBuffer.buffer.asFloat32List()[maxi]);
    return Category(pred.key, pred.value);
  }

  Future<Uint8List> process_debug_image(Image image) async {
    // image = grayscale(image);
    var _inputImage = TensorImage.fromImage(image);
    _inputImage = _preProcess();

    return await _inputImage.getBuffer().asUint8List();
    // gray2rgb(rgb2grayf(_inputImage.tensorBuffer.buffer.asUint8List())));
  }

  void close() {
    if (interpreter != null) {
      interpreter.close();
    }
  }

  int argmax(var arr) {
    double max = 0;
    var maxi = 0;
    for (int i = 0; i < arr.length; i += 1) {
      if (arr[i] > max) {
        max = arr[i];
        maxi = i;
      }
    }

    return maxi;
  }
}

MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);

  return pq.first;
}

int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}
