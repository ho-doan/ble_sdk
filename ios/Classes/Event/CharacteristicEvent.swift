//
//  CharacteristicEvent.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import Flutter

class CharacteristicEvent: NSObject, FlutterStreamHandler{
    private var sink:FlutterEventSink? = nil
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }
    
    func sendData(_ data: CharacteristicValue) {
        sink?(try? data.serializedData())
        return
    }
}
