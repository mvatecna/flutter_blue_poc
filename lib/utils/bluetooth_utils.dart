import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poc_bluetooth/view/home_page/home_page_provider.dart';

class BluetoothUtils {
  BluetoothUtils._internal();

  static BluetoothUtils get instance => BluetoothUtils._internal();
  final flutterBlue = FlutterBluePlus.instance;

  Future<void> scanBluetooth(WidgetRef ref) async {
    List<ScanResult> list = [];
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final res in results) {
        log("scanResults $res");
        list.add(res);
      }
    });
    flutterBlue.startScan(timeout: const Duration(seconds: 5));
    Future.delayed(const Duration(seconds: 3), () {
      flutterBlue.stopScan();
      log("STOP Scanning");
      ref.read(bluetootDevicesProvider.notifier).state = list;
    });
  }
}
