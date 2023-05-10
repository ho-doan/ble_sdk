//
//  CBService+Extension.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import CoreBluetooth

extension CBService{
    func detectCharacteristics(withDeviceId:String)->[Characteristic]{
        return (self.characteristics ?? []).map { $0.mapCharacteristic(withDeviceId: withDeviceId, withServiceId: self.uuid.uuidString) }
    }
    func detectService(withDeviceId:String)->Service{
        return Service.with{
            s in
            s.characteristics = self.detectCharacteristics(withDeviceId: withDeviceId)
            s.serviceID = self.uuid.uuidString
        }
    }
}
