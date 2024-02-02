import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flash_scan_plugin_method_channel.dart';

abstract class FlashScanPluginPlatform extends PlatformInterface {
  /// Constructs a FlashScanPluginPlatform.
  FlashScanPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlashScanPluginPlatform _instance = MethodChannelFlashScanPlugin();

  /// The default instance of [FlashScanPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlashScanPlugin].
  static FlashScanPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlashScanPluginPlatform] when
  /// they register themselves.
  static set instance(FlashScanPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int> triggerBroadcast() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
