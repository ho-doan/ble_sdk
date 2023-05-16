import Flutter
import CoreBluetooth
import UIKit

public class BleSdkPlugin: NSObject, FlutterPlugin {
    var bleClient: BleClient!
    //MARK: - event
    let logEvent = LogEvent()
    let characteristicEvent = CharacteristicEvent()
    let stateConnectEvent = StateConnectEvent()
    let stateBluetoothEvent = StateBluetoothEvent()
    let scanResultEvent = ScanResultEvent()
    
    //MARK: - channel
    let characteristicChannel = CharacteristicChannel()
    let permissionChannel = PermissionChannel()
    let connectChannel = ConnectChannel()
    let checkBondedChannel = CheckBondedChannel()
    let discoveredServicesChannel = DiscoveredServicesChannel()
    
    public override init() {
        super.init()
        self.bleClient = BleClient(delegate: self)
    }
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ble_sdk", binaryMessenger: registrar.messenger())
        let instance = BleSdkPlugin()
        FlutterEventChannel(name: "ble_sdk_scan", binaryMessenger: registrar.messenger()).setStreamHandler(instance.scanResultEvent)
        FlutterEventChannel(name: "ble_sdk_connect", binaryMessenger: registrar.messenger()).setStreamHandler(instance.stateConnectEvent)
        FlutterEventChannel(name: "ble_sdk_bluetooth", binaryMessenger: registrar.messenger()).setStreamHandler(instance.stateBluetoothEvent)
        FlutterEventChannel(name: "ble_sdk_logs", binaryMessenger: registrar.messenger()).setStreamHandler(instance.logEvent)
        FlutterEventChannel(name: "ble_sdk_char", binaryMessenger: registrar.messenger()).setStreamHandler(instance.characteristicEvent)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "turnOnBluetooth": turnOnBluetooth(result: result)
        case "requestPermission": requestPermission(result: result)
        case "requestPermissionSettings": requestPermission(result: result)
        case "checkPermission": checkPermission(result: result)
        case "startScan": startScan(call, result: result)
        case "stopScan": stopScan(result: result)
        case "discoverServices": discoverServices(result: result)
        case "connect": connect(call, result: result)
        case "disconnect": disconnect(result: result)
        case "writeCharacteristic": writeCharacteristic(call,result: result)
        case "writeCharacteristicNoResponse": writeCharacteristicNoResponse(call,result: result)
        case "readCharacteristic": readCharacteristic(call,result: result)
        case "setNotification": setNotification(call,result: result)
        case "setIndication": setIndication(call,result: result)
        case "checkBonded": checkBonded(result: result)
            //TODO: chua lam
        case "unBonded": turnOnBluetooth(result: result)
        case "isBluetoothAvailable": isBluetoothAvailable(result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func connect(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? ConnectModel.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        connectChannel.create(result)
        let data = bleClient.connect(model: model)
        if !data{
            connectChannel.close(false)
        }
    }

    
    private func startScan(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? ScanModel.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        bleClient.startScan(services: model.services)
        result(nil)
    }
    
    private func writeCharacteristic(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? CharacteristicValue.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        characteristicChannel.create(result)
        let data = bleClient.writeCharacteristic(value: model)
        if !data{
            characteristicChannel.close(CharacteristicValue.init())
        }
    }
    private func readCharacteristic(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? Characteristic.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        characteristicChannel.create(result)
        let data = bleClient.readCharacteristic(model)
        if !data{
            characteristicChannel.close(CharacteristicValue.init())
        }
    }
    
    private func writeCharacteristicNoResponse(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? CharacteristicValue.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        let data = bleClient.writeCharacteristic(value: model)
        result(data)
    }
    
    private func stopScan(result:@escaping FlutterResult){
        bleClient.stopScan()
        result(nil)
    }
    
    private func disconnect(result:@escaping FlutterResult){
        bleClient.disconnect()
        result(true)
    }
    
    private func setNotification(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? Characteristic.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        result(bleClient.notificationCharacteristic(model))
    }
    
    private func setIndication(_ call: FlutterMethodCall,result:@escaping FlutterResult){
        guard let model = try? Characteristic.init(serializedData: call.arguments.parserData()) else{
            result(FlutterError(code: "1", message: "parser data error", details: nil))
            return
        }
        result(bleClient.notificationCharacteristic(model))
    }
    
    private func checkBonded(result:@escaping FlutterResult){
        checkBondedChannel.create(result)
        let bonded = bleClient.checkBonded()
        if bonded {
            checkBondedChannel.close(true)
        }
    }
    
    private func turnOnBluetooth(result:@escaping FlutterResult){
        guard let settingsUrl = URL(string: "App-Prefs:Bluetooth") else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    private func discoverServices(result:@escaping FlutterResult){
        discoveredServicesChannel.create(result)
        let data = bleClient.discoverServices()
        if !data{
            discoveredServicesChannel.close(Services.init())
        }
    }
    
    private func isBluetoothAvailable(result:@escaping FlutterResult){
        result(bleClient.isBluetoothAvailable())
    }
    
    private func checkPermission(result:@escaping FlutterResult){
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .allowedAlways: result(0)
            case .notDetermined: result(1)
            case .restricted: result(1)
            case .denied: result(2)
            @unknown default:
                result(2)
            }
        } else if #available(iOS 13.0, *) {
            switch CBCentralManager().authorization {
            case .allowedAlways: result(0)
            case .notDetermined: result(1)
            case .restricted: result(1)
            case .denied: result(2)
            @unknown default:
                result(2)
            }
        }else{
            print("ios version < 13")
            result(0)
        }
    }
    
    private func requestPermission(result:@escaping FlutterResult){
        showAlertRequest()
        result(nil)
    }
    
    private func showAlertRequest(){
        let alertController = UIAlertController(title: "Bluetooth permission is currently disabled for the application. Enable Bluetooth from the application settings.", message: "", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        if let vc = UIApplication.shared.delegate?.window??.rootViewController  as? FlutterViewController {
            vc.present(alertController, animated: true, completion: nil)
        }
        return
    }
}

extension BleSdkPlugin: BleClientDelegate{
    func bonded(_ bonded: Bool) {
        checkBondedChannel.close(bonded)
    }
    
    func bleState(_ state: StateBluetooth) {
        stateBluetoothEvent.sendData(state)
    }
    
    func onScanResult(_ result: BluetoothBLEModel) {
        scanResultEvent.sendData(result)
    }
    
    func onServicesDiscovered(_ services: [CBService], _ deviceId: String) {
        discoveredServicesChannel.close(Services.with({
            s in s.services = services.map{
                $0.detectService(withDeviceId: deviceId)
            }
        }))
    }
    
    func onConnectionStateChange(_ state: StateConnect) {
        if state == .connected{
            connectChannel.close(true)
        }
        if state == .disconnected{
            connectChannel.close(false)
        }
        stateConnectEvent.sendData(state)
    }
    
    func onCharacteristicValue(_ characteristic: CBCharacteristic,_ deviceId: String?, _ value: Data) {
        let result = CharacteristicValue.with{
            c in
            c.characteristic = characteristic.mapCharacteristic(
                withDeviceId: deviceId ?? "", withServiceId: characteristic.service?.uuid.uuidString ?? "")
            c.data = value.lst()
        }
        characteristicChannel.close(result)
        characteristicEvent.sendData(result)
    }
}
