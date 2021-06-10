import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'classifier.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads: 1, String modelType: "character"})
      : super(numThreads: numThreads, modelType: modelType);

  // @override
  // String get modelName => Classifer.modelName;
  // @override
  // String get modelType => modelType;
  // @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
