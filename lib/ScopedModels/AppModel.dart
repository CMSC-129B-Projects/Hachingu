import 'package:scoped_model/scoped_model.dart';

class AppModel extends Model {
  int counter = 0;
  bool _localNotifs = false;

  void increment() {
    counter += 1;
    print(counter);
    notifyListeners();
  }
}
