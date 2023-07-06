//
//  BleClient.swift
//  ble_sdk
//
//  Created by Doan Ho on 10/05/2023.
//

import Foundation
import CoreBluetooth

protocol BleClientDelegate: NSObjectProtocol{
    func bonded(_ bonded: Bool)
    func bleState(_ state: StateBluetooth)
    func onScanResult(_ result: BluetoothBLEModel)
    func onServicesDiscovered(_ services: [CBService], _ deviceId: String)
    func onConnectionStateChange(_ state: StateConnect)
    func onCharacteristicValue(_ characteristic: CBCharacteristic,_ deviceId: String?, _ value: Data)
}

class BleClient : NSObject{
    private var manager: CBCentralManager!
    private var isScanning = false
    private var deviceCurrent:CBPeripheral? = nil
    private var devicesScanner: [String:CBPeripheral] = [:]
    private var charNotifications: [CBCharacteristic] = []
    
    private var services:[CBUUID] = []
    
    private var countCheckBonded = 0
    
    let delegate: BleClientDelegate
    
    //MARK: - init
    init(delegate: BleClientDelegate) {
        self.delegate = delegate
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: .main)
    }
    //MARK: - start Scan
    func startScan(services: [String]){
        self.services = services.map{ service in CBUUID(string: service)}
        if self.manager.state == .poweredOn{
            self.isScanning = true
            self.manager.scanForPeripherals(withServices: self.services, options: nil)
        }
    }
    //MARK: - stop Scan
    func stopScan(){
        self.isScanning = false
        self.manager.stopScan()
    }
    //MARK: - getService
    func getService(_ serviceId: String)->CBService?{
        return self.deviceCurrent?.services?.first(where: {$0.uuid.uuidString.lowercased() == serviceId.lowercased()})
    }
    //MARK: - getCharacteristic
    private func getCharacteristic(_ serviceId:String,_ characteristicId:String)->CBCharacteristic?{
        return getService(serviceId)?.characteristics?.first(where: {$0.uuid.uuidString.lowercased() == characteristicId.lowercased()})
    }
    //MARK: - connect
    func connect(model: ConnectModel)->Bool{
        let peripheral = self.devicesScanner.first(where: {$0.key == model.deviceID})?.value
        if peripheral != nil{
            stopScan()
            self.manager.connect(peripheral!, options: nil)
            return true
        }else{
            return false
        }
    }
    //MARK: - disconnect
    func  disconnect(){
        if let peripheral = self.deviceCurrent{
            self.manager.cancelPeripheralConnection(peripheral)
            self.deviceCurrent = nil
        }
    }
    //MARK: - writeCharacteristic
    func  writeCharacteristic(value: CharacteristicValue)->Bool{
        if deviceCurrent == nil{
            return false
        }
        if let characteristic = getCharacteristic(value.characteristic.serviceID, value.characteristic.characteristicID){
            let valueBites:[UInt8] = value.data.map{UInt8($0)}
            let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: valueBites.count)
            uint8Pointer.initialize(from: valueBites, count: value.data.count)
            let msgData = Data(bytes: uint8Pointer, count: value.data.count)
            deviceCurrent?.writeValue(msgData, for: characteristic, type: .withResponse)
            return true
        }
        return false
    }
    //MARK: - readCharacteristic
    func  readCharacteristic(_ value: Characteristic)->Bool{
        if deviceCurrent == nil{
            return false
        }
        if let characteristic = getCharacteristic(value.serviceID, value.characteristicID){
            deviceCurrent?.readValue(for: characteristic)
            return true
        }
        return false
    }
    //MARK: - discoverServices
    func  discoverServices()->Bool{
        if deviceCurrent == nil{
            return false
        }
        deviceCurrent?.discoverServices(nil)
        return true
    }
    //MARK: - notificationCharacteristic
    func  notificationCharacteristic(_ value: Characteristic)->Bool{
        if let characteristic = getCharacteristic(value.serviceID, value.characteristicID){
            return notificationCharacteristic(characteristic)
        }
        return false
    }
    private func  notificationCharacteristic(_ characteristic: CBCharacteristic)->Bool{
        if deviceCurrent == nil{
            return false
        }
        if charNotifications.first(where: {$0 == characteristic}) != nil{
            return true
        }
        charNotifications.append(characteristic)
        deviceCurrent?.setNotifyValue(true, for: characteristic)
        return true
    }
    
    //MARK: - checkBonded
    func checkBonded() -> Bool{
        let services: [CBService] = deviceCurrent?.services ?? []
        var servicesCheck: [CBService] = services.filter({self.services.contains($0.uuid)})
        servicesCheck.reverse()
        
        var lstChar: [CBCharacteristic] = []
        
        for service in servicesCheck{
            for characteristic in service.characteristics ?? []{
                if characteristic.properties.contains(.notifyEncryptionRequired){
                    lstChar.append(characteristic)
                }
                if characteristic.properties.contains(.indicateEncryptionRequired){
                    lstChar.append(characteristic)
                }
                if characteristic.properties.contains(.indicate){
                    lstChar.append(characteristic)
                }
                if characteristic.properties.contains(.notify){
                    lstChar.append(characteristic)
                }

            }
        }
        self.countCheckBonded = lstChar.count
        for characteristic in lstChar{
            print("char check bonded \(characteristic.uuid.uuidString)")
            let _ = notificationCharacteristic(characteristic)
        }
        return false
    }
    
    func isBluetoothAvailable()->Bool{
        return manager.state == .poweredOn
    }
}

extension BleClient: CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOn : delegate.bleState(StateBluetooth.on)
        case .unknown:
            delegate.bleState(StateBluetooth.on)
        case .resetting:
            delegate.bleState(StateBluetooth.notSupport)
        case .unsupported:
            delegate.bleState(StateBluetooth.notSupport)
        case .unauthorized:
            delegate.bleState(StateBluetooth.notSupport)
        case .poweredOff:
            delegate.bleState(StateBluetooth.off)
        @unknown default:
            delegate.bleState(StateBluetooth.notSupport)
        }
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let err = error{
            print("centralManager didFailToConnect \(String(describing: peripheral.name)) \(String(describing: err))")
        }
        self.delegate.bonded(false)
        self.delegate.onConnectionStateChange(StateConnect.disconnected)
        self.charNotifications = []
        self.deviceCurrent = nil
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let err = error{
            print("centralManager didFailToConnect \(String(describing: peripheral.name)) \(String(describing: err.localizedDescription))")
        }
        self.delegate.bonded(false)
        self.delegate.onConnectionStateChange(StateConnect.disconnected)
        self.charNotifications = []
        self.deviceCurrent = nil
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        self.deviceCurrent = peripheral
        self.delegate.onConnectionStateChange(StateConnect.connected)
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.devicesScanner[peripheral.identifier.uuidString] = peripheral
        var model = BluetoothBLEModel()
        model.bonded = false
        model.id = peripheral.identifier.uuidString
        model.name = peripheral.name ?? ""
        self.delegate.onScanResult(model)
    }
}

extension BleClient: CBPeripheralDelegate{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error{
            print("err didDiscoverServices: \(err)")
            return
        }
        let services = peripheral.services ?? []
        for service in services{
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error{
            print("error didDiscoverCharacteristicsFor \(err)")
        }
        let services = peripheral.services ?? []
        if services.last?.uuid == service.uuid{
            self.delegate.onServicesDiscovered(services, peripheral.identifier.uuidString)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error as NSError? {
            print("Error : \(e), Description : \(e.userInfo.description)")
            if e.domain == CBATTErrorDomain && e.code == 15{
                self.delegate.bonded(false)
                self.countCheckBonded = -1
            }
        }
        print("didUpdateNotificationStateFor \(characteristic.uuid.uuidString)")
        self.countCheckBonded = self.countCheckBonded - 1
        if self.countCheckBonded == 0{
            self.delegate.bonded(true)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error{
            print("err didWriteValueFor: \(err)")
            return
        }
        if let value = characteristic.value{
            self.delegate.onCharacteristicValue(characteristic,self.deviceCurrent?.identifier.uuidString, value)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error{
            print("err didUpdateValueFor: \(err)")
            return
        }
        if let value = characteristic.value{
            self.delegate.onCharacteristicValue(characteristic,self.deviceCurrent?.identifier.uuidString, value)
        }
    }
}
