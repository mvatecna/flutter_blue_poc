import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:poc_bluetooth/widget/characteristic_tile.dart';
import 'package:poc_bluetooth/widget/descriptor_tile.dart';
import 'package:poc_bluetooth/widget/service_tile.dart';

class DevicePage extends StatelessWidget {
  const DevicePage({required this.device, super.key});

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device.name),
        actions: [
          StreamBuilder<BluetoothDeviceState>(
            stream: device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (_, snapshot) {
              VoidCallback? onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () async => await device.disconnect();
                  text = "DISCONNECT";
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () async => await device.connect();
                  text = "CONNECT";
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return TextButton(
                onPressed: onPressed,
                child: Text(text),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<BluetoothDeviceState>(
              stream: device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (_, snapshot) {
                final data = snapshot.data;
                return Column(
                  children: [
                    ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          data == BluetoothDeviceState.connected
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth_disabled),
                          data == BluetoothDeviceState.connected
                              ? StreamBuilder<int>(
                                  stream: rssiStream(),
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.hasData ? "${snapshot.data}dBm" : "",
                                      style: Theme.of(context).textTheme.bodySmall,
                                    );
                                  },
                                )
                              : const SizedBox(),
                        ],
                      ),
                      title: Text("Device is ${snapshot.data.toString().split(".")[1]}."),
                      subtitle: Text(
                        "${device.id}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: StreamBuilder<bool>(
                        stream: device.isDiscoveringServices,
                        initialData: false,
                        builder: (_, snapshot) => IndexedStack(
                          index: snapshot.data! ? 1 : 0,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => device.discoverServices(),
                            ),
                            IconButton(
                              icon: SizedBox(
                                width: 18.0,
                                height: 18.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.onInverseSurface),
                                ),
                              ),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            StreamBuilder<int>(
              stream: device.mtu,
              initialData: 0,
              builder: (_, snapshot) => ListTile(
                title: const Text("MTU Size"),
                subtitle: Text("${snapshot.data} bytes"),
                trailing: Platform.isAndroid
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => device.requestMtu(223),
                      )
                    : null,
              ),
            ),
            StreamBuilder<List<BluetoothService>>(
              stream: device.services,
              initialData: const [],
              builder: (_, snapshot) {
                return Column(
                  children: snapshot.data!
                      .map(
                        (bluetoothService) => ServiceTile(
                          service: bluetoothService,
                          characteristicTiles: bluetoothService.characteristics
                              .map(
                                (characteristic) => CharacteristicTile(
                                  characteristic: characteristic,
                                  onReadPressed: () => characteristic.read(),
                                  onWritePressed: () async {
                                    await characteristic.write(_getRandomBytes(), withoutResponse: true);
                                    await characteristic.read();
                                  },
                                  onNotificationPressed: () async {
                                    await characteristic.setNotifyValue(!characteristic.isNotifying);
                                    await characteristic.read();
                                  },
                                  descriptorTiles: characteristic.descriptors
                                      .map(
                                        (bluetoothDescriptor) => DescriptorTile(
                                          descriptor: bluetoothDescriptor,
                                          onReadPressed: () => bluetoothDescriptor.read(),
                                          onWritePressed: () => bluetoothDescriptor.write(_getRandomBytes()),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<int> rssiStream() async* {
    var isConnected = true;
    final subscription = device.state.listen((state) {
      isConnected = state == BluetoothDeviceState.connected;
    });
    while (isConnected) {
      yield await device.readRssi();
      await Future.delayed(const Duration(seconds: 1));
    }
    subscription.cancel();

    /// Device disconnected, stopping RSSI stream
  }

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
    ];
  }
}
