import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bluetootDevicesProvider = StateProvider<List<ScanResult>>((ref) => []);
