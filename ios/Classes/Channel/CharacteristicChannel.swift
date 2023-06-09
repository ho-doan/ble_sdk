//
//  CharacteristicChannel.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import Flutter

class CharacteristicChannel{
    private var _result: FlutterResult? = nil
    func create(_ result:@escaping FlutterResult){
        self._result = result
    }
    
    func close(_ value: CharacteristicValue){
        DispatchQueue.global(qos: .userInteractive).async {
            if let result = self._result{
                result(try? value.serializedData())
                self._result = nil
            }
        }
    }
}
