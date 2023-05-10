//
//  Int+Extension.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
extension Int{
    func detectProperties()->[CharacteristicProperties]{
        let p0: CharacteristicProperties? = CharacteristicProperties.init(rawValue: self)
        if let p = p0{
            return [p]
        }
        var lst:[CharacteristicProperties] = []
        let ps = CharacteristicProperties.allCases
            .filter{$0 != .none}
            .map{$0.rawValue}.sorted(by: {$0 > $1})
        var index = self
        while index != 0{
            for i in ps{
                if index >= i{
                    lst.append(CharacteristicProperties.init(rawValue: i)!)
                    index -= i
                }
            }
        }
        return lst
    }
}
