import 'package:flutter_test/flutter_test.dart';
import 'package:flash_scan_plugin/flash_scan_plugin.dart';
import 'package:flash_scan_plugin/flash_scan_plugin_platform_interface.dart';
import 'package:flash_scan_plugin/flash_scan_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlashScanPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlashScanPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int> triggerBroadcast()  => Future.value(1);
}

void main() {
  final FlashScanPluginPlatform initialPlatform = FlashScanPluginPlatform.instance;

  test('$MethodChannelFlashScanPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlashScanPlugin>());
  });

  test('getPlatformVersion', () async {
    FlashScanPlugin flashScanPlugin = FlashScanPlugin();
    MockFlashScanPluginPlatform fakePlatform = MockFlashScanPluginPlatform();
    FlashScanPluginPlatform.instance = fakePlatform;

    expect(await flashScanPlugin.getPlatformVersion(), '42');
  });
}
