import 'package:flutter/material.dart';
import 'package:flash_scan_plugin/flash_scan_mixin.dart';

/// * Created by yulongmei.
/// * Date 2024/2/1.

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with FlashScanMixin {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('广播'),
      ),
      body: Center(
        child: Text('Scan Code: $_code'),
      ),
    );
  }

  @override
  Future<void> scanCodeHandle(String code) async {
    setState(() {
      _code = code;
    });
  }
}
