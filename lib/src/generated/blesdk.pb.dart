///
//  Generated code. Do not modify.
//  source: blesdk.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'blesdk.pbenum.dart';

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

class ServicesDiscovered extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServicesDiscovered', createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data')
    ..hasRequiredFields = false
  ;

  ServicesDiscovered._() : super();
  factory ServicesDiscovered({
    $core.Iterable<$core.String>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data.addAll(data);
    }
    return _result;
  }
  factory ServicesDiscovered.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServicesDiscovered.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServicesDiscovered clone() => ServicesDiscovered()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServicesDiscovered copyWith(void Function(ServicesDiscovered) updates) => super.copyWith((message) => updates(message as ServicesDiscovered)) as ServicesDiscovered; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServicesDiscovered create() => ServicesDiscovered._();
  ServicesDiscovered createEmptyInstance() => create();
  static $pb.PbList<ServicesDiscovered> createRepeated() => $pb.PbList<ServicesDiscovered>();
  @$core.pragma('dart2js:noInline')
  static ServicesDiscovered getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServicesDiscovered>(create);
  static ServicesDiscovered? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get data => $_getList(0);
}

class CharacteristicValue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CharacteristicValue', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'serviceId', protoName: 'serviceId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'characteristicId', protoName: 'characteristicId')
    ..p<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.K3)
    ..hasRequiredFields = false
  ;

  CharacteristicValue._() : super();
  factory CharacteristicValue({
    $core.String? serviceId,
    $core.String? characteristicId,
    $core.Iterable<$core.int>? data,
  }) {
    final _result = create();
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (characteristicId != null) {
      _result.characteristicId = characteristicId;
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
  $core.String get serviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get characteristicId => $_getSZ(1);
  @$pb.TagNumber(2)
  set characteristicId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCharacteristicId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCharacteristicId() => clearField(2);

  @$pb.TagNumber(4)
  $core.List<$core.int> get data => $_getList(2);
}

