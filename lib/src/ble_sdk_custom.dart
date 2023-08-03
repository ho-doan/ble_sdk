part of '../ble_sdk.dart';

class BleSdk extends BleSdkNative {
  BleSdk._();
  static final instance = BleSdk._();
  Future<List<CharacteristicValue>> writeCharacteristicVsNotify(
    CharacteristicValue value, {
    List<Characteristic>? notifications,
    int timeout = 500,
  }) async {
    List<CharacteristicValue> values;
    values = [];

    final completer = Completer<List<CharacteristicValue>>();
    late StreamSubscription<CharacteristicValue> listen;
    Timer? timer;
    listen = characteristicResult.listen((event) {
      if (timer != null) {
        timer!.cancel();
      }
      values.add(event);
      timer = Timer.periodic(Duration(milliseconds: timeout), (_) {
        timer!.cancel();
        listen.cancel();
        completer.complete(values);
      });
    });
    // final listNotifications = [
    //   value.characteristic,
    //   for (final notify in notifications ?? <Characteristic>[]) notify,
    // ].map(
    //   (e) => Future(() {
    //     if (e.properties.contains(CharacteristicProperties.NOTIFY)) {
    //       setNotification(e);
    //     }
    //     if (e.properties.contains(CharacteristicProperties.INDICATE)) {
    //       setIndication(e);
    //     }
    //   }),
    // );
    // final checkNotify = value.characteristic.properties
    //         .contains(CharacteristicProperties.NOTIFY) ||
    //     value.characteristic.properties
    //         .contains(CharacteristicProperties.INDICATE);
    // if (checkNotify) {
    //   await Future.forEach(listNotifications, (notify) => notify);
    //   await Future<void>.delayed(const Duration(milliseconds: 450));
    // }
    // final isWrite = await writeCharacteristicNoResponse(value);
    // if (!checkNotify) {
    //   await Future.forEach(listNotifications, (notify) => notify);
    // }
    final listNotifications = [
      value.characteristic,
      for (final notify in notifications ?? <Characteristic>[]) notify,
    ]
        .map(
          (e) => Future<bool>(() {
            if (e.properties.contains(CharacteristicProperties.NOTIFY)) {
              return setNotification(e);
            }
            if (e.properties.contains(CharacteristicProperties.INDICATE)) {
              return setIndication(e);
            }
            return Future.value(true);
          }),
        )
        .toList();
    final checkNotify = value.characteristic.properties
            .contains(CharacteristicProperties.NOTIFY) ||
        value.characteristic.properties
            .contains(CharacteristicProperties.INDICATE);
    if (checkNotify) {
      // final result = await Future.wait(listNotifications);
      // if (result.any((e) => e == false)) {
      //   return [];
      // }
      for (final notification in listNotifications) {
        await Future<void>.delayed(const Duration(milliseconds: 350));
        final r = await notification;
        if (!r) {
          return [];
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 450));
    }
    final isWrite = await writeCharacteristicNoResponse(value);
    if (!checkNotify) {
      for (final notification in listNotifications) {
        await Future<void>.delayed(const Duration(milliseconds: 350));
        final r = await notification;
        if (!r) {
          return [];
        }
      }
    }
    if (!isWrite) {
      listen.cancel();
      timer?.cancel();
      return values;
    }
    return completer.future;
  }
}
