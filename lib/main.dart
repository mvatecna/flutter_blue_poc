import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_bluetooth/constant/routes.dart';
import 'package:poc_bluetooth/view/details_bluetooth_device.dart';
import 'package:poc_bluetooth/view/home_page/home_page.dart';

void main() => runApp(
      ProviderScope(child: MyApp()),
    );

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      title: "POC Bluetooth",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
    );
  }

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: Routes.detailsBluetoothDevice,
        builder: (BuildContext context, GoRouterState state) {
          return DetailsBluetoothDevicePage(
            bluetoothDevice: state.extra as ScanResult,
          );
        },
      ),
    ],
  );
}
