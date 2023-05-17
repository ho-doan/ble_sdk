# ble_sdk

* [![ble_sdk version](https://img.shields.io/pub/v/ble_sdk?label=ble_sdk)](https://pub.dev/packages/ble_sdk)
[![ble_sdk size](https://img.shields.io/github/repo-size/ho-doan/ble_sdk)](https://github.com/ho-doan/ble_sdk)
[![ble_sdk issues](https://img.shields.io/github/issues/ho-doan/ble_sdk)](https://github.com/ho-doan/ble_sdk)
[![ble_sdk issues](https://img.shields.io/pub/likes/ble_sdk)](https://github.com/ho-doan/ble_sdk)
* Bluetooth Low Energy (BLE) plugin that can communicate with single device

## Futures

- BLE device discovery
- Connection BLE
- BLE status
- Connection BLE state
- Discover services
- Enable notification a characteristic
- Enable indication a characteristic
- Read a characteristic
- Write a characteristic

## Getting Started

### android

#### Android ProGuard rules

```txt
-keep class com.hodoan.ble_sdk.** { *; }
```

### ios

```plist
<key>NSBluetoothAlwaysUsageDescription</key>
<string>using BLE</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>using BLE</string>
```

### Usage

#### Scan Device

```dart
BleSdk.instance.startScan(services: ['1808'])
```

#### Stop Scan Device

```dart
BleSdk.instance.stopScan()
```

#### Connect Device

```dart
BleSdk.instance.connect(deviceId: '...')
```

#### Connect Device

```dart
BleSdk.instance.connect(deviceId: '...')
```

#### Device discovery

```dart
BleSdk.instance.discoverServices()
```
#### set notification a characteristic

```dart
BleSdk.instance.setNotification(Characteristic(
    characteristicId: '...',
    serviceId: '...',
    properties: [],
))
```
#### set indication a characteristic

```dart
BleSdk.instance.setIndication(Characteristic(
    characteristicId: '...',
    serviceId: '...',
    properties: [],
))
```
#### Read a characteristic

```dart
BleSdk.instance.readCharacteristic(Characteristic(
    characteristicId: '...',
    serviceId: '...',
    properties: [],
))
```
#### Write a characteristic

```dart
BleSdk.instance.readCharacteristic(CharacteristicValue(
    characteristic: ...,
    data: [],
))
```

#### Disconnect device

```dart
BleSdk.instance.disconnect()
```

#### Log Characteristic

```dart
BleSdk.instance.logResult.listen((_){})
```

#### Listen Read/Write All Characteristic

```dart
BleSdk.instance.characteristicResult.listen((_){})
```

#### Listen BLE ON/OFF

```dart
BleSdk.instance.stateBluetoothResult.listen((_){})
```

#### State Connect

```dart
BleSdk.instance.stateConnectResult.listen((_){})
```
