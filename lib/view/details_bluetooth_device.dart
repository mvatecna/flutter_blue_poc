import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailsBluetoothDevicePage extends ConsumerWidget {
  const DetailsBluetoothDevicePage({required this.bluetoothDevice, super.key});

  final ScanResult bluetoothDevice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bluetoothDevice.device.name == ""
            ? "unknown device"
            : bluetoothDevice.device.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ListTile(title: Text("id : ${bluetoothDevice.device.id}")),
              const Divider(),
              ListTile(title: Text("type : ${bluetoothDevice.device.type}")),
              const Divider(),
              ListTile(title: Text("RSSI : ${bluetoothDevice.rssi}")),
              const Divider(),
              ListTile(
                  title: Text(
                      "local name : ${bluetoothDevice.advertisementData.localName}")),
              const Divider(),
              ListTile(
                  title: Text(
                      "connectable : ${bluetoothDevice.advertisementData.connectable}")),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  // flutter
                },
                child: const Text("connect"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


              // onTap: () async {
              // flutterBlue.stopScan();
              // try {
              //   await device.connect();
              //   //do somtehing when connect
              // } on PlatformException catch (e) {
              //   if (e.code != 'already_connected') {
              //     rethrow;
              //   }
              // }
              // },