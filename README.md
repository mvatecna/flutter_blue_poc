# POC_Bluetooth

Un projet flutter pour créer un POC bluetooth

## Description

Créer un POC en utilisant le [protocole GATT](http://tvaira.free.fr/bts-sn/activites/activite-ble/bluetooth-ble.html#:~:text=et%20scan%20window)


### iOS
info.plist 
```plist
	<key>NSBluetoothAlwaysUsageDescription</key>
	<string>Need BLE permission</string>
	<key>NSBluetoothPeripheralUsageDescription</key>  
	<string>Need BLE permission</string>  
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>  
	<string>Need Location permission</string>  
	<key>NSLocationAlwaysUsageDescription</key>  
	<string>Need Location permission</string>  
	<key>NSLocationWhenInUseUsageDescription</key>  
	<string>Need Location permission</string>
```
### Android
AndroidManifest.xml
```xml
    <uses-permission android:name="android.permission.BLUETOOTH" />  
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />  
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/> 
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
    <uses-permission-sdk-23 android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### Remarques package [flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus)
il est disponible sur la branche plugin/flutter_blue_plus
sur iOS sa marche plutot bien sans trop de config sur Android c'est un peu plus aléatoire concernant la détection d'appareil bluetooth (j'ai tester avec un [Google Pixel 7](https://store.google.com/fr/product/pixel_7?hl=fr) et un [Xiaomi Poco F2 Pro](https://www.mi.com/fr/poco-f2-pro/))


### Remarques package [flutter_reactive_ble](https://pub.dev/packages/flutter_reactive_ble)
fonctionne beaucoup mieux il est developper pas les équipes de [PhiliphHue](https://github.com/PhilipsHue/flutter_reactive_ble) il a quand même quelque petit souci de connexion au appareil avec android, comme dit précédemment tester seulement avec 2 devices