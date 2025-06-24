import 'package:flutter/widgets.dart';

class AppLocaleProvider extends ChangeNotifier{
  String _locale = "en";
  String get AppLocal => _locale;
  set AppLocal (String local ){
    _locale = local;
    notifyListeners();
  }
}