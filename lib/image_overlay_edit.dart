
import 'dart:async';

import 'package:flutter/services.dart';

class ImageOverlayEdit {
  static const MethodChannel _channel =
      const MethodChannel('image_overlay_edit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
