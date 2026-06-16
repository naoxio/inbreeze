import 'package:wakelock_plus/wakelock_plus.dart';

class WakeLockService {
  static Future<void> setEnabled(bool enabled) async {
    try {
      if (enabled) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (e) {
      print('Error setting wake lock: $e');
    }
  }

  static Future<void> disable() async {
    await setEnabled(false);
  }
}
