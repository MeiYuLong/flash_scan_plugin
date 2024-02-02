import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// * Created by yulongmei.
/// * Date 2024/2/1.
class EventChannelFlashScanPlugin {

  EventChannelFlashScanPlugin._();
  factory EventChannelFlashScanPlugin() => _instance;
  static EventChannelFlashScanPlugin get _instance => EventChannelFlashScanPlugin._();

  final EventChannel eventChannel = const EventChannel('flash_scan_plugin_event');

  StreamSubscription? streamSubscription;
  Stream? stream;

  Stream start() {
    stream ??= eventChannel.receiveBroadcastStream();
    return stream!;
  }

  void listen(ValueChanged<String> codeHandle) {
    streamSubscription = start().listen((event) {
      if (event == null) return;
      codeHandle.call(event.toString());
    });
  }

  void cancel() {
   streamSubscription?.cancel();
  }
}