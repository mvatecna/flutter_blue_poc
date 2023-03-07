import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothOffPage extends StatelessWidget {
  const BluetoothOffPage({this.state, super.key});

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
            ),
            Text(
              "Bluetooth Adapter is ${state != null ? state.toString().substring(15) : "not available"}.",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
