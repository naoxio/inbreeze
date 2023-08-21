import 'dart:io' show Platform;

bool isDesktop() {
  try {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  } catch (e) {
    return false;
  }
}
