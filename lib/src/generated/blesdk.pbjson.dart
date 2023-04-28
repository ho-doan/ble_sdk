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
@$core.Deprecated('Use servicesDiscoveredDescriptor instead')
const ServicesDiscovered$json = const {
  '1': 'ServicesDiscovered',
  '2': const [
    const {'1': 'data', '3': 1, '4': 3, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `ServicesDiscovered`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicesDiscoveredDescriptor = $convert.base64Decode('ChJTZXJ2aWNlc0Rpc2NvdmVyZWQSEgoEZGF0YRgBIAMoCVIEZGF0YQ==');
@$core.Deprecated('Use characteristicValueDescriptor instead')
const CharacteristicValue$json = const {
  '1': 'CharacteristicValue',
  '2': const [
    const {'1': 'serviceId', '3': 1, '4': 1, '5': 9, '10': 'serviceId'},
    const {'1': 'characteristicId', '3': 2, '4': 1, '5': 9, '10': 'characteristicId'},
    const {
      '1': 'data',
      '3': 4,
      '4': 3,
      '5': 5,
      '8': const {'2': true},
      '10': 'data',
    },
  ],
};

/// Descriptor for `CharacteristicValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicValueDescriptor = $convert.base64Decode('ChNDaGFyYWN0ZXJpc3RpY1ZhbHVlEhwKCXNlcnZpY2VJZBgBIAEoCVIJc2VydmljZUlkEioKEGNoYXJhY3RlcmlzdGljSWQYAiABKAlSEGNoYXJhY3RlcmlzdGljSWQSFgoEZGF0YRgEIAMoBUICEAFSBGRhdGE=');
