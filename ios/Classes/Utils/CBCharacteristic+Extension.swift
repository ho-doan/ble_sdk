//
//  CBCharacteristic+Extension.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import CoreBluetooth

extension CBCharacteristic{
    func detectProperties()->[CharacteristicProperties]{
        var lst:[CharacteristicProperties] = []
        if self.properties.contains(.indicate){
            lst.append(.indicate)
        }
        if self.properties.contains(.notify){
            lst.append(.notify)
        }
        if self.properties.contains(.read){
            lst.append(.read)
        }
        if self.properties.contains(.write){
            lst.append(.write)
        }
        if self.properties.contains(.writeWithoutResponse){
            lst.append(.writeNoResponse)
        }
        if self.properties.contains(.authenticatedSignedWrites){
            lst.append(.signedWrite)
        }
        return lst
    }
    func mapCharacteristic(withDeviceId: String,withServiceId:String)->Characteristic{
        return Characteristic.with{
            c in
            c.properties = self.detectProperties()
            c.serviceID = withServiceId
            c.deviceID = withDeviceId
            c.characteristicID = self.uuid.uuidString
        }
    }
}
