import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

bool isDesktop() {
  try {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  } catch (e) {
    return false;
  }
}


bool isMobile() {
  try {
    return Platform.isAndroid || Platform.isIOS;
  } catch (e) {
    return false;
  }
}

bool isWeb() {
  try {
    return kIsWeb;
  } catch (e) {
    return false;
  }
}