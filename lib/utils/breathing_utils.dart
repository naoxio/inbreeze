import 'dart:async';

class BreathingUtils {
  static void cancelBreathCycleTimer(Timer? breathCycleTimer) {
    if (breathCycleTimer != null && breathCycleTimer.isActive) {
      breathCycleTimer.cancel();
    }
  }
}
