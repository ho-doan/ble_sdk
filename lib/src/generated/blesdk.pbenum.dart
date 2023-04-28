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
  static const StateConnect CONNECTING = StateConnect._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTING');
  static const StateConnect CONNECTED = StateConnect._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CONNECTED');
  static const StateConnect DISCONNECTING = StateConnect._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECTING');
  static const StateConnect DISCONNECTED = StateConnect._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DISCONNECTED');

  static const $core.List<StateConnect> values = <StateConnect> [
    CONNECTING,
    CONNECTED,
    DISCONNECTING,
    DISCONNECTED,
  ];

  static final $core.Map<$core.int, StateConnect> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StateConnect? valueOf($core.int value) => _byValue[value];

  const StateConnect._($core.int v, $core.String n) : super(v, n);
}

class StateBluetooth extends $pb.ProtobufEnum {
  static const StateBluetooth TURING_ON = StateBluetooth._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TURING_ON');
  static const StateBluetooth ON = StateBluetooth._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ON');
  static const StateBluetooth TURING_OFF = StateBluetooth._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'TURING_OFF');
  static const StateBluetooth OFF = StateBluetooth._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'OFF');
  static const StateBluetooth NOT_SUPPORT = StateBluetooth._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'NOT_SUPPORT');

  static const $core.List<StateBluetooth> values = <StateBluetooth> [
    TURING_ON,
    ON,
    TURING_OFF,
    OFF,
    NOT_SUPPORT,
  ];

  static final $core.Map<$core.int, StateBluetooth> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StateBluetooth? valueOf($core.int value) => _byValue[value];

  const StateBluetooth._($core.int v, $core.String n) : super(v, n);
}

