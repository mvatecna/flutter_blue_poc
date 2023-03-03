import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final flutterBlue = FlutterBluePlus.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = {};

  @override
  void initState() {
    _scanBluetooth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POC Bluetooth"),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _scanBluetooth(),
        child: ListView.builder(
          itemCount: devicesList.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final device = devicesList[index];
            return ListTile(
              title: Text(device.name == "" ? "unknown device" : device.name),
              subtitle: Text("${device.id}"),
              leading: const Icon(Icons.bluetooth_rounded),
              onTap: () async {
                flutterBlue.stopScan();
                try {
                  await device.connect();
                  //do somtehing when connect
                } on PlatformException catch (e) {
                  if (e.code != 'already_connected') {
                    rethrow;
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _scanBluetooth() async {
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final res in results) {
        log("scanResults $res");
        _addDeviceTolist(res.device);
      }
    });
    flutterBlue.startScan(timeout: const Duration(seconds: 10));
    Future.delayed(const Duration(seconds: 50), () {
      flutterBlue.stopScan();
      debugPrint("STOP");
    });
  }

  void _addDeviceTolist(BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      devicesList.add(device);
      setState(() {});
    }
  }
}
