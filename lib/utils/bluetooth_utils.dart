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

    /// start scanning
    flutterBlue.startScan(
      timeout: const Duration(seconds: 5),
      allowDuplicates: false,
    );

    /// listen scan result
    /// add to the list
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final res in results) {
        log("scanResults ${res.device.id}");
        list.add(res);
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      /// stop scan
      flutterBlue.stopScan();
      log("STOP Scanning");

      /// add list to view
      ref.read(bluetootDevicesProvider).clear();
      ref.read(bluetootDevicesProvider.notifier).state = list.toSet().toList();
    });
  }
}
