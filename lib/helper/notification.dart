import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class NotificationProvider extends ChangeNotifier {
  String? _message;

  String? get message => _message;

  void showMessage(String message) {
    _message = message;
    notifyListeners(); // Thông báo cho các người nghe (listener) về sự thay đổi trạng thái
  }

  void clearMessage() {
    _message = null;
    notifyListeners(); // Thông báo cho các người nghe (listener) về sự thay đổi trạng thái
  }
}

class SnackbarManager {
  static final SnackbarManager _instance = SnackbarManager._internal();

  factory SnackbarManager() {
    return _instance;
  }

  SnackbarManager._internal();

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static void showMessage(String message) {
    Scaffold(
      key: scaffoldKey,
    );
    
  }
}
