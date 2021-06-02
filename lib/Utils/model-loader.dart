import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart';
import 'dart:math';


abstract class ModelLoader {
  var interpreter;
  
  late TensorBuffer _outputBuffer;
  late TensorImage _inputImage;
  init() async {
    interpreter = await Interpreter.fromAsset(
        'assets\tflite-models\syllable-model.tflite');

    // predict(Image.file())
    predict2(image);
  }

  feedImage() {}

  predict(Image input) {
    var output = List<double>.empty(growable: true);
    interpreter.run(input, output);
    print(output);
  }

  predict2(Image image) {
    if (interpreter == null) {
      throw StateError('Cannot run inference, Intrepreter is null');
    }
    final pres = DateTime.now().millisecondsSinceEpoch;
    _inputImage = TensorImage.fromImage(image);
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('Time to load image: $pre ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('Time to run inference: $run ms');

    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();
    final pred = getTopProbability(labeledProb);

    return Category(pred.key, pred.value);
  }

  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }
}
