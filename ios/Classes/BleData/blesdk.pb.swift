// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: blesdk.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

enum StateConnect: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case connecting // = 0
  case connected // = 1
  case disconnecting // = 2
  case disconnected // = 3
  case UNRECOGNIZED(Int)

  init() {
    self = .connecting
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .connecting
    case 1: self = .connected
    case 2: self = .disconnecting
    case 3: self = .disconnected
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .connecting: return 0
    case .connected: return 1
    case .disconnecting: return 2
    case .disconnected: return 3
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension StateConnect: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [StateConnect] = [
    .connecting,
    .connected,
    .disconnecting,
    .disconnected,
  ]
}

#endif  // swift(>=4.2)

enum StateBluetooth: SwiftProtobuf.Enum {
  typealias RawValue = Int
  case turingOn // = 0
  case on // = 1
  case turingOff // = 2
  case off // = 3
  case notSupport // = 4
  case UNRECOGNIZED(Int)

  init() {
    self = .turingOn
  }

  init?(rawValue: Int) {
    switch rawValue {
    case 0: self = .turingOn
    case 1: self = .on
    case 2: self = .turingOff
    case 3: self = .off
    case 4: self = .notSupport
    default: self = .UNRECOGNIZED(rawValue)
    }
  }

  var rawValue: Int {
    switch self {
    case .turingOn: return 0
    case .on: return 1
    case .turingOff: return 2
    case .off: return 3
    case .notSupport: return 4
    case .UNRECOGNIZED(let i): return i
    }
  }

}

#if swift(>=4.2)

extension StateBluetooth: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  static var allCases: [StateBluetooth] = [
    .turingOn,
    .on,
    .turingOff,
    .off,
    .notSupport,
  ]
}

#endif  // swift(>=4.2)

struct BluetoothBLEModel {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var id: String = String()

  var name: String = String()

  var bonded: Bool = false

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Log {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var message: String = String()

  var characteristic: Characteristic {
    get {return _characteristic ?? Characteristic()}
    set {_characteristic = newValue}
  }
  /// Returns true if `characteristic` has been explicitly set.
  var hasCharacteristic: Bool {return self._characteristic != nil}
  /// Clears the value of `characteristic`. Subsequent reads from it will return its default value.
  mutating func clearCharacteristic() {self._characteristic = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _characteristic: Characteristic? = nil
}

struct Service {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var serviceID: String = String()

  var characteristics: [Characteristic] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Services {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var services: [Service] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Characteristic {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var characteristicID: String = String()

  var properties: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct CharacteristicValue {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var characteristic: Characteristic {
    get {return _characteristic ?? Characteristic()}
    set {_characteristic = newValue}
  }
  /// Returns true if `characteristic` has been explicitly set.
  var hasCharacteristic: Bool {return self._characteristic != nil}
  /// Clears the value of `characteristic`. Subsequent reads from it will return its default value.
  mutating func clearCharacteristic() {self._characteristic = nil}

  var data: [Int32] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _characteristic: Characteristic? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension StateConnect: @unchecked Sendable {}
extension StateBluetooth: @unchecked Sendable {}
extension BluetoothBLEModel: @unchecked Sendable {}
extension Log: @unchecked Sendable {}
extension Service: @unchecked Sendable {}
extension Services: @unchecked Sendable {}
extension Characteristic: @unchecked Sendable {}
extension CharacteristicValue: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension StateConnect: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "CONNECTING"),
    1: .same(proto: "CONNECTED"),
    2: .same(proto: "DISCONNECTING"),
    3: .same(proto: "DISCONNECTED"),
  ]
}

extension StateBluetooth: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "TURING_ON"),
    1: .same(proto: "ON"),
    2: .same(proto: "TURING_OFF"),
    3: .same(proto: "OFF"),
    4: .same(proto: "NOT_SUPPORT"),
  ]
}

extension BluetoothBLEModel: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "BluetoothBLEModel"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "id"),
    2: .same(proto: "name"),
    3: .same(proto: "bonded"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.id) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.name) }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.bonded) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.id.isEmpty {
      try visitor.visitSingularStringField(value: self.id, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if self.bonded != false {
      try visitor.visitSingularBoolField(value: self.bonded, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: BluetoothBLEModel, rhs: BluetoothBLEModel) -> Bool {
    if lhs.id != rhs.id {return false}
    if lhs.name != rhs.name {return false}
    if lhs.bonded != rhs.bonded {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Log: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Log"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "message"),
    2: .same(proto: "characteristic"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.message) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._characteristic) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.message.isEmpty {
      try visitor.visitSingularStringField(value: self.message, fieldNumber: 1)
    }
    try { if let v = self._characteristic {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Log, rhs: Log) -> Bool {
    if lhs.message != rhs.message {return false}
    if lhs._characteristic != rhs._characteristic {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Service: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Service"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "serviceId"),
    2: .same(proto: "characteristics"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.serviceID) }()
      case 2: try { try decoder.decodeRepeatedMessageField(value: &self.characteristics) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.serviceID.isEmpty {
      try visitor.visitSingularStringField(value: self.serviceID, fieldNumber: 1)
    }
    if !self.characteristics.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.characteristics, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Service, rhs: Service) -> Bool {
    if lhs.serviceID != rhs.serviceID {return false}
    if lhs.characteristics != rhs.characteristics {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Services: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Services"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "services"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.services) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.services.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.services, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Services, rhs: Services) -> Bool {
    if lhs.services != rhs.services {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Characteristic: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "Characteristic"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "characteristicId"),
    2: .same(proto: "properties"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.characteristicID) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.properties) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.characteristicID.isEmpty {
      try visitor.visitSingularStringField(value: self.characteristicID, fieldNumber: 1)
    }
    if !self.properties.isEmpty {
      try visitor.visitSingularStringField(value: self.properties, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Characteristic, rhs: Characteristic) -> Bool {
    if lhs.characteristicID != rhs.characteristicID {return false}
    if lhs.properties != rhs.properties {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension CharacteristicValue: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CharacteristicValue"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "characteristic"),
    4: .same(proto: "data"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._characteristic) }()
      case 4: try { try decoder.decodeRepeatedInt32Field(value: &self.data) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._characteristic {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    if !self.data.isEmpty {
      try visitor.visitPackedInt32Field(value: self.data, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: CharacteristicValue, rhs: CharacteristicValue) -> Bool {
    if lhs._characteristic != rhs._characteristic {return false}
    if lhs.data != rhs.data {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
