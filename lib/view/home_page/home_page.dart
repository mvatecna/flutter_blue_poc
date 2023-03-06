import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_bluetooth/constant/routes.dart';
import 'package:poc_bluetooth/utils/bluetooth_utils.dart';
import 'package:poc_bluetooth/view/home_page/home_page_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // final List<BluetoothDevice> devicesList = [];
  final bluetoothUtils = BluetoothUtils.instance;

  @override
  void initState() {
    bluetoothUtils.scanBluetooth(ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicesList = ref.watch(bluetootDevicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("POC Bluetooth"),
      ),
      body: StreamBuilder<BluetoothState>(
          stream: BluetoothUtils.instance.flutterBlue.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            debugPrint("state bluetooth $state");
            if (state == BluetoothState.on) {
              return RefreshIndicator(
                onRefresh: () async => await bluetoothUtils.scanBluetooth(ref),
                child: devicesList.isEmpty
                    ? const LinearProgressIndicator()
                    : ListView.builder(
                        itemCount: devicesList.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final bluetoothDevice = devicesList[index];
                          return ListTile(
                            title: Text(bluetoothDevice.device.name == ""
                                ? "unknown device"
                                : bluetoothDevice.device.name),
                            subtitle: Text(
                              "${bluetoothDevice.device.id}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            leading: const Icon(Icons.bluetooth_rounded),
                            onTap: () => context.push(
                              Routes.detailsBluetoothDevice,
                              extra: bluetoothDevice,
                            ),
                          );
                        },
                      ),
              );
            }
            return BluetoothOffScreen(state: state);
          }),
      // body:
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
