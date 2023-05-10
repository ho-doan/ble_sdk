//
//  Any+Extension.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import Flutter

extension Any?{
    func parserData()->Data{
        let flutterData = self as! FlutterStandardTypedData
        return Data(flutterData.data)
    }
}
extension Data{
    func lst()->[Int32]{
        let valueUint8 = [UInt8](self)
        return valueUint8.map{Int32($0) & 255}
    }
}
