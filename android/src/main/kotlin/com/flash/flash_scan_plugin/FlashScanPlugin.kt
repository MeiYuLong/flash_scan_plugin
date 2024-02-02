package com.flash.flash_scan_plugin

import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.ServiceConnection
import android.os.BatteryManager
import android.os.IBinder
import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlashScanPlugin */
class FlashScanPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var  eventChannel: EventChannel
  private lateinit var applicationcontext: Context
  private lateinit var filter: IntentFilter

  private val METHOD_CHANNEL = "flash_scan_plugin"
  private val EVENT_CHANNEL = "flash_scan_plugin_event"

  companion object {
    const val RES_ACTION = "android.intent.action.SCANRESULT"
    const val RES_ACTION01 = "com.android.server.scannersevice.broadcast"
  }



  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    filter = IntentFilter()
    filter.addAction(RES_ACTION)
    filter.addAction(RES_ACTION01)
    /// 事件通信
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL)
    channel.setMethodCallHandler(this)

    /// 数据流监听通信
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL)
    eventChannel.setStreamHandler(object: EventChannel.StreamHandler {
      private var broadcastReceiver: ScanBroadcastReceiver? = null
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        broadcastReceiver = ScanBroadcastReceiver()
        broadcastReceiver?.events = events
        applicationcontext.registerReceiver(broadcastReceiver, filter)
      }
      override fun onCancel(arguments: Any?) {
        if (broadcastReceiver != null) {
          applicationcontext.unregisterReceiver(broadcastReceiver)
          broadcastReceiver = null
        }
      }
    })
    applicationcontext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "triggerBroadcast" -> {
        // 手动调起需要供应商提供SDK 目前不支持
//        val intent = Intent()
//        intent.action = RES_ACTION
//        intent.addCategory(applicationcontext.packageName)
//        intent.component = ComponentName(applicationcontext.packageName, "com.flash.flash_scan_plugin.ScanBroadcastReceiver")
//        applicationcontext.sendBroadcast(intent)
        result.success(1)
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

class ScanBroadcastReceiver(): BroadcastReceiver() {

  var events: EventChannel.EventSink? = null

  override fun onReceive(context: Context?, intent: Intent?) {
    val scanResult = intent?.getStringExtra("value") ?: return
    print("scanResult ---------------------!")
    /* 如果条码长度>0，解码成功。如果条码长度等于0解码失败。*/
    if (scanResult.isNotEmpty()) {
      val code = scanResult.replace("\r\n", "").replace("\n", "")
      events?.success(code)
    } else {
      /*
       * 扫描失败提示使用有两个条件：
       * 1，需要先将扫描失败提示接口打开只能在广播模式下使用，其他模式无法调用。
       * 2，通过判断条码长度来判定是否解码成功，当长度等于0时表示解码失败。
       */
      print("Scan Error!")
    }
  }
}