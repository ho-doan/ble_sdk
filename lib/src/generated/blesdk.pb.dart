///
//  Generated code. Do not modify.
//  source: blesdk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'blesdk.pbenum.dart';

export 'blesdk.pbenum.dart';

class ScanModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScanModel', createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services')
    ..hasRequiredFields = false
  ;

  ScanModel._() : super();
  factory ScanModel({
    $core.Iterable<$core.String>? services,
  }) {
    final _result = create();
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory ScanModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanModel clone() => ScanModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanModel copyWith(void Function(ScanModel) updates) => super.copyWith((message) => updates(message as ScanModel)) as ScanModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanModel create() => ScanModel._();
  ScanModel createEmptyInstance() => create();
  static $pb.PbList<ScanModel> createRepeated() => $pb.PbList<ScanModel>();
  @$core.pragma('dart2js:noInline')
  static ScanModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanModel>(create);
  static ScanModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get services => $_getList(0);
}

class ConnectModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectModel', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId', protoName: 'deviceId')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createBonded', protoName: 'createBonded')
    ..hasRequiredFields = false
  ;

  ConnectModel._() : super();
  factory ConnectModel({
    $core.String? deviceId,
    $core.bool? createBonded,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (createBonded != null) {
      _result.createBonded = createBonded;
    }
    return _result;
  }
  factory ConnectModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectModel clone() => ConnectModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectModel copyWith(void Function(ConnectModel) updates) => super.copyWith((message) => updates(message as ConnectModel)) as ConnectModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectModel create() => ConnectModel._();
  ConnectModel createEmptyInstance() => create();
  static $pb.PbList<ConnectModel> createRepeated() => $pb.PbList<ConnectModel>();
  @$core.pragma('dart2js:noInline')
  static ConnectModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectModel>(create);
  static ConnectModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get createBonded => $_getBF(1);
  @$pb.TagNumber(2)
  set createBonded($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreateBonded() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreateBonded() => clearField(2);
}

class BluetoothBLEModel extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BluetoothBLEModel', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bonded')
    ..hasRequiredFields = false
  ;

  BluetoothBLEModel._() : super();
  factory BluetoothBLEModel({
    $core.String? id,
    $core.String? name,
    $core.bool? bonded,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (bonded != null) {
      _result.bonded = bonded;
    }
    return _result;
  }
  factory BluetoothBLEModel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BluetoothBLEModel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BluetoothBLEModel clone() => BluetoothBLEModel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BluetoothBLEModel copyWith(void Function(BluetoothBLEModel) updates) => super.copyWith((message) => updates(message as BluetoothBLEModel)) as BluetoothBLEModel; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BluetoothBLEModel create() => BluetoothBLEModel._();
  BluetoothBLEModel createEmptyInstance() => create();
  static $pb.PbList<BluetoothBLEModel> createRepeated() => $pb.PbList<BluetoothBLEModel>();
  @$core.pragma('dart2js:noInline')
  static BluetoothBLEModel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BluetoothBLEModel>(create);
  static BluetoothBLEModel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get bonded => $_getBF(2);
  @$pb.TagNumber(3)
  set bonded($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBonded() => $_has(2);
  @$pb.TagNumber(3)
  void clearBonded() => clearField(3);
}

class Log extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Log', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..aOM<Characteristic>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristic', subBuilder: Characteristic.create)
    ..hasRequiredFields = false
  ;

  Log._() : super();
  factory Log({
    $core.String? message,
    Characteristic? characteristic,
  }) {
    final _result = create();
    if (message != null) {
      _result.message = message;
    }
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    return _result;
  }
  factory Log.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Log.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Log clone() => Log()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Log copyWith(void Function(Log) updates) => super.copyWith((message) => updates(message as Log)) as Log; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Log create() => Log._();
  Log createEmptyInstance() => create();
  static $pb.PbList<Log> createRepeated() => $pb.PbList<Log>();
  @$core.pragma('dart2js:noInline')
  static Log getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Log>(create);
  static Log? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get message => $_getSZ(0);
  @$pb.TagNumber(1)
  set message($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessage() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessage() => clearField(1);

  @$pb.TagNumber(2)
  Characteristic get characteristic => $_getN(1);
  @$pb.TagNumber(2)
  set characteristic(Characteristic v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCharacteristic() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacteristic() => clearField(2);
  @$pb.TagNumber(2)
  Characteristic ensureCharacteristic() => $_ensure(1);
}

class Service extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Service', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId', protoName: 'serviceId')
    ..pc<Characteristic>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: Characteristic.create)
    ..hasRequiredFields = false
  ;

  Service._() : super();
  factory Service({
    $core.String? serviceId,
    $core.Iterable<Characteristic>? characteristics,
  }) {
    final _result = create();
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (characteristics != null) {
      _result.characteristics.addAll(characteristics);
    }
    return _result;
  }
  factory Service.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Service.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Service clone() => Service()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Service copyWith(void Function(Service) updates) => super.copyWith((message) => updates(message as Service)) as Service; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Service create() => Service._();
  Service createEmptyInstance() => create();
  static $pb.PbList<Service> createRepeated() => $pb.PbList<Service>();
  @$core.pragma('dart2js:noInline')
  static Service getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Service>(create);
  static Service? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<Characteristic> get characteristics => $_getList(1);
}

class Services extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Services', createEmptyInstance: create)
    ..pc<Service>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'services', $pb.PbFieldType.PM, subBuilder: Service.create)
    ..hasRequiredFields = false
  ;

  Services._() : super();
  factory Services({
    $core.Iterable<Service>? services,
  }) {
    final _result = create();
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory Services.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Services.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Services clone() => Services()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Services copyWith(void Function(Services) updates) => super.copyWith((message) => updates(message as Services)) as Services; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Services create() => Services._();
  Services createEmptyInstance() => create();
  static $pb.PbList<Services> createRepeated() => $pb.PbList<Services>();
  @$core.pragma('dart2js:noInline')
  static Services getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Services>(create);
  static Services? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Service> get services => $_getList(0);
}

class Characteristic extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Characteristic', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicId', protoName: 'characteristicId')
    ..pc<CharacteristicProperties>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'properties', $pb.PbFieldType.KE, valueOf: CharacteristicProperties.valueOf, enumValues: CharacteristicProperties.values, defaultEnumValue: CharacteristicProperties.NONE)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId', protoName: 'serviceId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false
  ;

  Characteristic._() : super();
  factory Characteristic({
    $core.String? characteristicId,
    $core.Iterable<CharacteristicProperties>? properties,
    $core.String? serviceId,
    $core.String? deviceId,
  }) {
    final _result = create();
    if (characteristicId != null) {
      _result.characteristicId = characteristicId;
    }
    if (properties != null) {
      _result.properties.addAll(properties);
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    return _result;
  }
  factory Characteristic.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Characteristic.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Characteristic clone() => Characteristic()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Characteristic copyWith(void Function(Characteristic) updates) => super.copyWith((message) => updates(message as Characteristic)) as Characteristic; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Characteristic create() => Characteristic._();
  Characteristic createEmptyInstance() => create();
  static $pb.PbList<Characteristic> createRepeated() => $pb.PbList<Characteristic>();
  @$core.pragma('dart2js:noInline')
  static Characteristic getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Characteristic>(create);
  static Characteristic? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get characteristicId => $_getSZ(0);
  @$pb.TagNumber(1)
  set characteristicId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristicId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristicId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<CharacteristicProperties> get properties => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get serviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasServiceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get deviceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set deviceId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDeviceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceId() => clearField(4);
}

class CharacteristicValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicValue', createEmptyInstance: create)
    ..aOM<Characteristic>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristic', subBuilder: Characteristic.create)
    ..p<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.K3)
    ..hasRequiredFields = false
  ;

  CharacteristicValue._() : super();
  factory CharacteristicValue({
    Characteristic? characteristic,
    $core.Iterable<$core.int>? data,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory CharacteristicValue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicValue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicValue clone() => CharacteristicValue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicValue copyWith(void Function(CharacteristicValue) updates) => super.copyWith((message) => updates(message as CharacteristicValue)) as CharacteristicValue; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicValue create() => CharacteristicValue._();
  CharacteristicValue createEmptyInstance() => create();
  static $pb.PbList<CharacteristicValue> createRepeated() => $pb.PbList<CharacteristicValue>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicValue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicValue>(create);
  static CharacteristicValue? _defaultInstance;

  @$pb.TagNumber(1)
  Characteristic get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(Characteristic v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  Characteristic ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getList(1);
}

