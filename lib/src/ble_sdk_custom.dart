part of '../ble_sdk.dart';

class BleSdk extends BleSdkNative {
  BleSdk._();
  static final instance = BleSdk._();
  Future<List<CharacteristicValue>> writeCharacteristicVsNotify(
    CharacteristicValue value, {
    List<Characteristic>? notifications,
    int timeout = 550,
  }) async {
    // ignore: prefer_final_locals
    List<CharacteristicValue> values = List<CharacteristicValue>.from([]);

    final completer = Completer<List<CharacteristicValue>>();
    late StreamSubscription<CharacteristicValue> listen;
    Timer? timer;
    listen = characteristicResult.listen((event) {
      if (timer != null) {
        timer!.cancel();
      }
      values.add(event);
      timer = Timer.periodic(Duration(milliseconds: timeout), (timer) {
        timer.cancel();
        listen.cancel();
        completer.complete(values);
      });
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
    await Future.forEach(listNotifications, (notify) => notify);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final isWrite = await writeCharacteristicNoResponse(value);
    if (!isWrite) {
      listen.cancel();
      timer?.cancel();
      return values;
    }
    return completer.future;
  }
}