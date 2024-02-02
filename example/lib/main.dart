import 'package:flash_scan_plugin_example/ScanPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flash_scan_plugin/flash_scan_plugin.dart';
import 'package:flash_scan_plugin/flash_scan_mixin.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    routes: <String, WidgetBuilder> {
      '/scan': (BuildContext context) => ScanPage()
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flashScanPlugin = FlashScanPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flashScanPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('Running on: $_platformVersion\n'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings_overscan),
        onPressed: () {
          Navigator.of(context).pushNamed('/scan');
        },
      ),
    );
  }

}
