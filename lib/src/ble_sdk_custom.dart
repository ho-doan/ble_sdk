part of '../ble_sdk.dart';

class BleSdk extends BleSdkNative {
  BleSdk._();
  static final instance = BleSdk._();
  Future<List<CharacteristicValue>> writeCharacteristicVsNotify(
    CharacteristicValue value, {
    List<Characteristic>? notifications,
    int timeout = 3550,
  }) async {
    List<CharacteristicValue> values;
    values = [];

    final completer = Completer<List<CharacteristicValue>>();
    late StreamSubscription<CharacteristicValue> listen;
    Timer? timer;
    listen = characteristicResult.listen((event) {
      log('data ${event.data}');
      if (timer != null) {
        timer.cancel();
      }
      values.add(event);
      // timer = Timer.periodic(Duration(milliseconds: timeout), (timer) {
      //   timer.cancel();
      //   listen.cancel();
      //   completer.complete(values);
      // });
    });
    final listNotifications = [
      value.characteristic,
      for (final notify in notifications ?? <Characteristic>[]) notify,
    ].map(
      (e) => Future(() {
        if (e.properties.contains(CharacteristicProperties.NOTIFY)) {
          setNotification(e);
        }
        if (e.properties.contains(CharacteristicProperties.INDICATE)) {
          setIndication(e);
        }
      }),
    );
    final checkNotify = value.characteristic.properties
            .contains(CharacteristicProperties.NOTIFY) ||
        value.characteristic.properties
            .contains(CharacteristicProperties.INDICATE);
    if (checkNotify) {
      await Future.forEach(listNotifications, (notify) => notify);
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    final isWrite = await writeCharacteristicNoResponse(value);
    if (!checkNotify) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      await Future.forEach(listNotifications, (notify) => notify);
    }
    if (!isWrite) {
      listen.cancel();
      timer?.cancel();
      return values;
    }
    return completer.future;
  }
}
