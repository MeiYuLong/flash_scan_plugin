import 'dart:async';
import 'package:flutter/material.dart';
import 'flash_scan_plugin_event_channel.dart';

/// * Created by yulongmei.
/// * Date 2024/2/1.

mixin FlashScanMixin<T extends StatefulWidget> on State<T> {
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    streamSubscription = EventChannelFlashScanPlugin().start().listen((event) {
      if (event == null) return;
      scanCodeHandle(event.toString());
    });
  }

  Future<void> scanCodeHandle(String code);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription.cancel();
    EventChannelFlashScanPlugin().cancel();
  }
}