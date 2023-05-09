///
//  Generated code. Do not modify.
//  source: blesdk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class StateConnect extends $pb.ProtobufEnum {
  static const StateConnect unKnow = StateConnect._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'unKnow');
  static const StateConnect connecting = StateConnect._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'connecting');
  static const StateConnect connected = StateConnect._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'connected');
  static const StateConnect disconnecting = StateConnect._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'disconnecting');
  static const StateConnect disconnected = StateConnect._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'disconnected');

  static const $core.List<StateConnect> values = <StateConnect> [
    unKnow,
    connecting,
    connected,
    disconnecting,
    disconnected,
  ];

  static final $core.Map<$core.int, StateConnect> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StateConnect? valueOf($core.int value) => _byValue[value];

  const StateConnect._($core.int v, $core.String n) : super(v, n);
}

class PermissionResult extends $pb.ProtobufEnum {
  static const PermissionResult granted = PermissionResult._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'granted');
  static const PermissionResult notGranted = PermissionResult._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'notGranted');
  static const PermissionResult denied = PermissionResult._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'denied');

  static const $core.List<PermissionResult> values = <PermissionResult> [
    granted,
    notGranted,
    denied,
  ];

  static final $core.Map<$core.int, PermissionResult> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PermissionResult? valueOf($core.int value) => _byValue[value];

  const PermissionResult._($core.int v, $core.String n) : super(v, n);
}

class CharacteristicProperties extends $pb.ProtobufEnum {
  static const CharacteristicProperties NONE = CharacteristicProperties._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NONE');
  static const CharacteristicProperties READ = CharacteristicProperties._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'READ');
  static const CharacteristicProperties WRITE_NO_RESPONSE = CharacteristicProperties._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WRITE_NO_RESPONSE');
  static const CharacteristicProperties WRITE = CharacteristicProperties._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'WRITE');
  static const CharacteristicProperties NOTIFY = CharacteristicProperties._(16, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOTIFY');
  static const CharacteristicProperties INDICATE = CharacteristicProperties._(32, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'INDICATE');
  static const CharacteristicProperties SIGNED_WRITE = CharacteristicProperties._(64, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SIGNED_WRITE');

  static const $core.List<CharacteristicProperties> values = <CharacteristicProperties> [
    NONE,
    READ,
    WRITE_NO_RESPONSE,
    WRITE,
    NOTIFY,
    INDICATE,
    SIGNED_WRITE,
  ];

  static final $core.Map<$core.int, CharacteristicProperties> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CharacteristicProperties? valueOf($core.int value) => _byValue[value];

  const CharacteristicProperties._($core.int v, $core.String n) : super(v, n);
}

class StateBluetooth extends $pb.ProtobufEnum {
  static const StateBluetooth turningOn = StateBluetooth._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'turningOn');
  static const StateBluetooth on = StateBluetooth._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'on');
  static const StateBluetooth turningOff = StateBluetooth._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'turningOff');
  static const StateBluetooth off = StateBluetooth._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'off');
  static const StateBluetooth notSupport = StateBluetooth._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'notSupport');

  static const $core.List<StateBluetooth> values = <StateBluetooth> [
    turningOn,
    on,
    turningOff,
    off,
    notSupport,
  ];

  static final $core.Map<$core.int, StateBluetooth> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StateBluetooth? valueOf($core.int value) => _byValue[value];

  const StateBluetooth._($core.int v, $core.String n) : super(v, n);
}

