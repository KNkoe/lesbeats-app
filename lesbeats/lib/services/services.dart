import 'package:flutter/widgets.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      debugPrint('The app is paused');
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('The app is resumed');
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('The app is inactive');
    } else if (state == AppLifecycleState.detached) {
      debugPrint('The app is detached');
    }
  }
}
