import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class GlobalObject {
  User? user;
}

class GlobalObjectProvider extends ChangeNotifier {
  GlobalObject _globalObject = GlobalObject();

  GlobalObject get globalObject => _globalObject;

  // Add any methods to update the global object

  // Example:
  void updateGlobalObject(GlobalObject newObject) {
    _globalObject = newObject;
    notifyListeners();
  }
}
