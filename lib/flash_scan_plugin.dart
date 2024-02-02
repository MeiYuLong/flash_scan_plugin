
import 'flash_scan_plugin_platform_interface.dart';

/// Test
class FlashScanPlugin {
  Future<String?> getPlatformVersion() {
    return FlashScanPluginPlatform.instance.getPlatformVersion();
  }

  Future<int> triggerBroadcast() {
    return FlashScanPluginPlatform.instance.triggerBroadcast();
  }
}
