///
//  Generated code. Do not modify.
//  source: blesdk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use stateConnectDescriptor instead')
const StateConnect$json = const {
  '1': 'StateConnect',
  '2': const [
    const {'1': 'CONNECTING', '2': 0},
    const {'1': 'CONNECTED', '2': 1},
    const {'1': 'DISCONNECTING', '2': 2},
    const {'1': 'DISCONNECTED', '2': 3},
  ],
};

/// Descriptor for `StateConnect`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stateConnectDescriptor = $convert.base64Decode('CgxTdGF0ZUNvbm5lY3QSDgoKQ09OTkVDVElORxAAEg0KCUNPTk5FQ1RFRBABEhEKDURJU0NPTk5FQ1RJTkcQAhIQCgxESVNDT05ORUNURUQQAw==');
@$core.Deprecated('Use characteristicPropertiesDescriptor instead')
const CharacteristicProperties$json = const {
  '1': 'CharacteristicProperties',
  '2': const [
    const {'1': 'NONE', '2': 0},
    const {'1': 'READ', '2': 2},
    const {'1': 'WRITE_NO_RESPONSE', '2': 4},
    const {'1': 'WRITE', '2': 8},
    const {'1': 'NOTIFY', '2': 16},
    const {'1': 'INDICATE', '2': 32},
    const {'1': 'SIGNED_WRITE', '2': 64},
  ],
};

/// Descriptor for `CharacteristicProperties`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List characteristicPropertiesDescriptor = $convert.base64Decode('ChhDaGFyYWN0ZXJpc3RpY1Byb3BlcnRpZXMSCAoETk9ORRAAEggKBFJFQUQQAhIVChFXUklURV9OT19SRVNQT05TRRAEEgkKBVdSSVRFEAgSCgoGTk9USUZZEBASDAoISU5ESUNBVEUQIBIQCgxTSUdORURfV1JJVEUQQA==');
@$core.Deprecated('Use stateBluetoothDescriptor instead')
const StateBluetooth$json = const {
  '1': 'StateBluetooth',
  '2': const [
    const {'1': 'TURING_ON', '2': 0},
    const {'1': 'ON', '2': 1},
    const {'1': 'TURING_OFF', '2': 2},
    const {'1': 'OFF', '2': 3},
    const {'1': 'NOT_SUPPORT', '2': 4},
  ],
};

/// Descriptor for `StateBluetooth`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stateBluetoothDescriptor = $convert.base64Decode('Cg5TdGF0ZUJsdWV0b290aBINCglUVVJJTkdfT04QABIGCgJPThABEg4KClRVUklOR19PRkYQAhIHCgNPRkYQAxIPCgtOT1RfU1VQUE9SVBAE');
@$core.Deprecated('Use scanModelDescriptor instead')
const ScanModel$json = const {
  '1': 'ScanModel',
  '2': const [
    const {'1': 'services', '3': 1, '4': 3, '5': 9, '10': 'services'},
  ],
};

/// Descriptor for `ScanModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanModelDescriptor = $convert.base64Decode('CglTY2FuTW9kZWwSGgoIc2VydmljZXMYASADKAlSCHNlcnZpY2Vz');
@$core.Deprecated('Use connectModelDescriptor instead')
const ConnectModel$json = const {
  '1': 'ConnectModel',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'createBonded', '3': 2, '4': 1, '5': 8, '10': 'createBonded'},
  ],
};

/// Descriptor for `ConnectModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectModelDescriptor = $convert.base64Decode('CgxDb25uZWN0TW9kZWwSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlkEiIKDGNyZWF0ZUJvbmRlZBgCIAEoCFIMY3JlYXRlQm9uZGVk');
@$core.Deprecated('Use bluetoothBLEModelDescriptor instead')
const BluetoothBLEModel$json = const {
  '1': 'BluetoothBLEModel',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'bonded', '3': 3, '4': 1, '5': 8, '10': 'bonded'},
  ],
};

/// Descriptor for `BluetoothBLEModel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bluetoothBLEModelDescriptor = $convert.base64Decode('ChFCbHVldG9vdGhCTEVNb2RlbBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIWCgZib25kZWQYAyABKAhSBmJvbmRlZA==');
@$core.Deprecated('Use logDescriptor instead')
const Log$json = const {
  '1': 'Log',
  '2': const [
    const {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'characteristic', '3': 2, '4': 1, '5': 11, '6': '.Characteristic', '10': 'characteristic'},
  ],
};

/// Descriptor for `Log`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logDescriptor = $convert.base64Decode('CgNMb2cSGAoHbWVzc2FnZRgBIAEoCVIHbWVzc2FnZRI3Cg5jaGFyYWN0ZXJpc3RpYxgCIAEoCzIPLkNoYXJhY3RlcmlzdGljUg5jaGFyYWN0ZXJpc3RpYw==');
@$core.Deprecated('Use serviceDescriptor instead')
const Service$json = const {
  '1': 'Service',
  '2': const [
    const {'1': 'serviceId', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'characteristics', '3': 2, '4': 3, '5': 11, '6': '.Characteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `Service`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDescriptor = $convert.base64Decode('CgdTZXJ2aWNlEhwKCXNlcnZpY2VJZBgBIAEoCVIJc2VydmljZUlkEjkKD2NoYXJhY3RlcmlzdGljcxgCIAMoCzIPLkNoYXJhY3RlcmlzdGljUg9jaGFyYWN0ZXJpc3RpY3M=');
@$core.Deprecated('Use servicesDescriptor instead')
const Services$json = const {
  '1': 'Services',
  '2': const [
    const {'1': 'services', '3': 1, '4': 3, '5': 11, '6': '.Service', '10': 'services'},
  ],
};

/// Descriptor for `Services`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicesDescriptor = $convert.base64Decode('CghTZXJ2aWNlcxIkCghzZXJ2aWNlcxgBIAMoCzIILlNlcnZpY2VSCHNlcnZpY2Vz');
@$core.Deprecated('Use characteristicDescriptor instead')
const Characteristic$json = const {
  '1': 'Characteristic',
  '2': const [
    const {'1': 'characteristicId', '3': 1, '4': 1, '5': 9, '10': 'characteristicId'},
    const {'1': 'properties', '3': 2, '4': 3, '5': 14, '6': '.CharacteristicProperties', '10': 'properties'},
    const {'1': 'serviceId', '3': 3, '4': 1, '5': 9, '10': 'serviceId'},
  ],
};

/// Descriptor for `Characteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicDescriptor = $convert.base64Decode('Cg5DaGFyYWN0ZXJpc3RpYxIqChBjaGFyYWN0ZXJpc3RpY0lkGAEgASgJUhBjaGFyYWN0ZXJpc3RpY0lkEjkKCnByb3BlcnRpZXMYAiADKA4yGS5DaGFyYWN0ZXJpc3RpY1Byb3BlcnRpZXNSCnByb3BlcnRpZXMSHAoJc2VydmljZUlkGAMgASgJUglzZXJ2aWNlSWQ=');
@$core.Deprecated('Use characteristicValueDescriptor instead')
const CharacteristicValue$json = const {
  '1': 'CharacteristicValue',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.Characteristic', '10': 'characteristic'},
    const {
      '1': 'data',
      '3': 2,
      '4': 3,
      '5': 5,
      '8': const {'2': true},
      '10': 'data',
    },
  ],
};

/// Descriptor for `CharacteristicValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicValueDescriptor = $convert.base64Decode('ChNDaGFyYWN0ZXJpc3RpY1ZhbHVlEjcKDmNoYXJhY3RlcmlzdGljGAEgASgLMg8uQ2hhcmFjdGVyaXN0aWNSDmNoYXJhY3RlcmlzdGljEhYKBGRhdGEYAiADKAVCAhABUgRkYXRh');
