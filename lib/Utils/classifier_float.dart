import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'classifier.dart';

class ClassifierFloat extends Classifier {
  ClassifierFloat({int numThreads}) : super(numThreads: numThreads);

  @override
  String get modelName => 'tflite-models/mobilenet_v1_1.0_224_float.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
}
