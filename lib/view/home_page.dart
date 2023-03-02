import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = {};

  void _addDeviceTolist(BluetoothDevice device) {
    if (!devicesList.contains(device)) {
      setState(() {
        devicesList.add(device);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (final device in devices) {
        _addDeviceTolist(device);
      }
    });
    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POC Bluetooth"),
      ),
      body: ListView.builder(
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
    );
  }
}
