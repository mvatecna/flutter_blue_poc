import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:poc_bluetooth/view/bluetooth_off_page.dart';
import 'package:poc_bluetooth/view/find_device_page.dart';

void main() {
  runApp(
    const FlutterBlueApp(),
  );
}

class FlutterBlueApp extends StatelessWidget {
  const FlutterBlueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBluePlus.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            debugPrint("BluetoothState $state");
            if (state == BluetoothState.on) {
              return const FindDevicesPage();
            }
            return BluetoothOffPage(state: state);
          }),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
    );
  }
}
