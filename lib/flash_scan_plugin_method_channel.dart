import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flash_scan_plugin_platform_interface.dart';

/// An implementation of [FlashScanPluginPlatform] that uses method channels.
class MethodChannelFlashScanPlugin extends FlashScanPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flash_scan_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int> triggerBroadcast() async {
    if (Platform.isIOS) return Future.value(0);
    final result = await methodChannel.invokeMethod('triggerBroadcast');
    return result;
  }
}
