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

  final String _labelsFileName = 'assets/model-labels/character-labels.txt';

  final int _labelsLength = 30;

  var _probabilityProcessor;

  List<String> labels;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

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
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

  Uint8List rgb2gray(List<int> image) {
    Uint8 zero;
    Uint8List gray_image = Uint8List(_inputShape[1] * _inputShape[2]);
    // List.filled(_inputShape[1] * _inputShape[2], zero) as Uint8List;
    // .map((e) => Uint8(e))
    // .toList();

    for (int i = 0; i < gray_image.length; i += 1) {
      gray_image[i] =
          ((image[i * 3] + image[(i * 3) + 1] + image[(i * 3) + 2]) ~/
              (3 * 255));
    }

    return gray_image;
  }

  Float32List rgb2grayf(List<int> image) {
    Float32List gray_image = Float32List(_inputShape[1] * _inputShape[2]);
    // List.filled(_inputShape[1] * _inputShape[2], zero) as Uint8List;
    // .map((e) => Uint8(e))
    // .toList();

    for (int i = 0; i < gray_image.length; i += 1) {
      gray_image[i] =
          ((image[i * 3] + image[(i * 3) + 1] + image[(i * 3) + 2]) /
              (3 * 255));
    }

    return gray_image;
  }

  Category predict(Image image) {
    if (interpreter == null) {
      throw StateError('Cannot run inference, Intrepreter is null');
    }
    image = grayscale(image);
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage.fromImage(image);
    _inputImage = _preProcess();
    // print('buffer');
    // print(_inputImage.tensorBuffer.buffer.asUint8List().toString());
    // print(_inputImage.tensorBuffer.buffer.asUint8List().length);
    // _inputImage.loadRgbPixels(
    //     rgb2gray(_inputImage.tensorBuffer.buffer.asUint8List()), [28, 28, 1]);
    // _inputImage.loadRgbPixels(_inputImage., [28,28,1])
    // _inputImage.loadTensorBuffer(_inputImage.getTensorBuffer());

    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms ');
    print(_inputShape);
    print(_inputImage.width);
    print(_inputImage.height);
    // print(_inputImage.buffer.toString());
    print(rgb2gray(_inputImage.tensorBuffer.buffer.asUint8List())
        .buffer
        .asUint8List()
        .toString());
    print(rgb2gray(_inputImage.tensorBuffer.buffer.asUint8List())
        .buffer
        .lengthInBytes
        .toString());
    print("lizt");
    print(_inputImage.buffer.asUint8List());

    print('types');
    print(_inputImage.buffer);
    print(rgb2gray(_inputImage.tensorBuffer.buffer.asUint8List()).buffer);
    // print()
    print(_inputImage.buffer.lengthInBytes);
    print(_outputShape);
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(
        // _inputImage.buffer,
        rgb2grayf(_inputImage.tensorBuffer.buffer.asUint8List())
            .buffer
            .asFloat32List()
            .reshape([1, 28, 28, 1]),
        _outputBuffer.getBuffer()
        // List.filled(30, 0).reshape([1, 30])

        );
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    return Category(pred.key, pred.value);
  }

  void close() {
    if (interpreter != null) {
      interpreter.close();
    }
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
