import 'package:flutter/widgets.dart';

class DurationNotifier with ChangeNotifier {
  String _duartion = "";
  String get duration => _duartion;
  void setDuration(String newDuration){
    _duartion = newDuration;
    notifyListeners();
  }
}