import 'package:flutter/material.dart';

// Stub implementation for window_manager
class WindowManagerStub {
  static Future<void> ensureInitialized() async {}
  static Future<void> waitUntilReadyToShow(WindowOptions options, Function callback) async {
    callback();
  }
  static Future<void> show() async {}
  static Future<void> focus() async {}
}

class WindowOptions {
  Size? size;
  bool? center;
  String? title;
  Color? backgroundColor;
  bool? skipTaskbar;
  TitleBarStyle? titleBarStyle;

  WindowOptions({
    this.size,
    this.center,
    this.title,
    this.backgroundColor,
    this.skipTaskbar,
    this.titleBarStyle,
  });
}

enum TitleBarStyle {
  normal,
  hidden,
  hiddenInset,
}

