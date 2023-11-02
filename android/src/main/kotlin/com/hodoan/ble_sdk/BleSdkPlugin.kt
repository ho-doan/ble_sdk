package com.hodoan.ble_sdk

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.ActivityCompat
import com.hodoan.ble_sdk.ProtobufModel.*
import com.hodoan.ble_sdk.ble.BleClient
import com.hodoan.ble_sdk.ble.IBleClientCallBack
import com.hodoan.ble_sdk.channel.*
import com.hodoan.ble_sdk.event.*
import com.hodoan.ble_sdk.utils.DetectCharProperties
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener

/** BleSdkPlugin */
class BleSdkPlugin : FlutterPlugin, MethodCallHandler, IBleClientCallBack, ActivityAware,
        RequestPermissionsResultListener {
    private lateinit var channel: MethodChannel

    private lateinit var activity: Activity
    private lateinit var context: Context
    private lateinit var bleClient: BleClient

    private val scanEvent = ScanResultEvent()
    private val stateBluetoothEvent = StateBluetoothEvent()
    private val stateConnectEvent = StateConnectEvent()
    private val logEvent = LogEvent()
    private val characteristicEvent = CharacteristicEvent()

    private val characteristicChannel = CharacteristicChannel()
    private val checkBondedChannel = CheckBondedChannel()
    private val discoveredServicesChannel = DiscoveredServicesChannel()
    private val connectChannel = ConnectChannel()
    private val permissionChannel = PermissionChannel()

    private var devices: List<BluetoothBLEModel> = listOf()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "ble_sdk")
        channel.setMethodCallHandler(this)
        BleClient.listenLocation(context, this)
        initialSdk()
        EventChannel(binding.binaryMessenger, "ble_sdk_scan").setStreamHandler(scanEvent)
        EventChannel(binding.binaryMessenger, "ble_sdk_connect").setStreamHandler(stateConnectEvent)
        EventChannel(binding.binaryMessenger, "ble_sdk_bluetooth").setStreamHandler(
                stateBluetoothEvent
        )
        EventChannel(binding.binaryMessenger, "ble_sdk_logs").setStreamHandler(
                logEvent
        )
        EventChannel(binding.binaryMessenger, "ble_sdk_char").setStreamHandler(
                characteristicEvent
        )
    }

    private fun getManager(context: Context): BluetoothManager? {
        return context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager?
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialSdk" -> initialSdk(result)
            "turnOnBluetooth" -> turnOnBluetooth(result)
            "turnOnLocation" -> turnOnLocation(result)
            "requestPermission" -> requestPermission(result)
            "requestPermissionSettings" -> requestPermissionSettings(result)
            "checkPermission" -> checkPermission(result)
            "startScan" -> startScan(call, result)
            "stopScan" -> stopScan(result)
            "discoverServices" -> discoverServices(result)
            "connect" -> connect(call, result)
            "disconnect" -> disconnect(result)
            "writeCharacteristic" -> writeCharacteristic(call, result)
            "writeCharacteristicNoResponse" -> writeCharacteristicNoResponse(call, result)
            "readCharacteristic" -> readCharacteristic(call, result)
            "setNotification" -> setNotification(call, result)
            "setIndication" -> setIndication(call, result)
            "checkBonded" -> checkBonded(result)
            "unBonded" -> unBonded(call, result)
            "isBluetoothAvailable" -> isBluetoothAvailable(result)
            "isLocationAvailable" -> isLocationAvailable(result)
            else -> result.notImplemented()
        }
    }

    //#region onMethodCall
    private fun turnOnBluetooth(result: Result) {
        enableBluetooth()
        result.success(null)
    }

    private fun turnOnLocation(result: Result) {
        enableLocation()
        result.success(null)
    }

    private fun initialSdk(result: Result? = null): Boolean {
        if (this::bleClient.isInitialized) return true
//        val checkPer = checkPermissionConnect() && checkPermissionScan()
//        if (this::activity.isInitialized && !checkPer) {
//            requestPermission()
//            return false
//        }
        if (!checkLocation()) {
//            if (this::activity.isInitialized) {
//                enableLocation()
//            }
            result?.error("1", "Please enable location", null)
            return false
        }
        val manager = getManager(context)
        if (manager == null || manager.adapter == null || manager.adapter?.isEnabled == false) {
//            if (this::activity.isInitialized) {
//                enableBluetooth()
//            }
            result?.error("2", "Please enable Bluetooth", null)
            return false
        }
        bleClient = BleClient(context, manager.adapter, this)
        bleClient.listen(context)
        return true
    }

    private fun requestPermission(result: Result) {
        permissionChannel.createRequest(result)
        requestPermission()
    }

    private fun requestPermissionSettings(result: Result) {
        val i = Intent()
        i.action = Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        i.addCategory(Intent.CATEGORY_DEFAULT)
        i.data = Uri.parse("package:" + context.packageName)
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        i.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY)
        i.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS)
        activity.startActivity(i)
        result.success(null)
    }

    private fun checkPermission(result: Result) {
        result.success(if (checkPermissionConnect() && checkPermissionScan()) 0 else 2)
    }

    private fun startScan(call: MethodCall, result: Result) {
        devices = listOf()
        val scanModel = ScanModel.parseFrom(call.arguments as ByteArray)
        bleClient.scan(scanModel.servicesList)
        result.success(null)
    }

    private fun stopScan(result: Result) {
        bleClient.stopScan()
        result.success(null)
    }

    private fun discoverServices(result: Result) {
        bleClient.discoverServices()
        discoveredServicesChannel.createRequest(result)
    }

    private fun connect(call: MethodCall, result: Result) {
        val connectModel = ConnectModel.parseFrom(call.arguments as ByteArray)
        val connect = bleClient.connect(connectModel)
        if (!connect) {
            result.success(false)
            return
        }
        connectChannel.createRequest(result)
    }

    private fun disconnect(result: Result) {
        bleClient.disconnect()
        result.success(false)
        return
    }

    private fun writeCharacteristic(call: MethodCall, result: Result) {
        val charValue = CharacteristicValue.parseFrom(call.arguments as ByteArray)
        logEvent.success(
                Log.newBuilder().setCharacteristic(charValue.characteristic)
                        .setMessage("data write " + charValue.dataList.joinToString(", ")).build()
        )
        characteristicChannel.createRequest(result)
        val isResult = bleClient.writeCharacteristic(charValue)
        if (!isResult) {
            characteristicChannel.closeRequest(CharacteristicValue.getDefaultInstance())
            return
        }
        if (!charValue.characteristic.propertiesList.contains(CharacteristicProperties.NOTIFY)) {
            characteristicChannel.closeRequest(CharacteristicValue.getDefaultInstance())
            return
        }
        if (!charValue.characteristic.propertiesList.contains(CharacteristicProperties.INDICATE)) {
            characteristicChannel.closeRequest(CharacteristicValue.getDefaultInstance())
            return
        }
    }

    private fun writeCharacteristicNoResponse(call: MethodCall, result: Result) {
        val charValue = CharacteristicValue.parseFrom(call.arguments as ByteArray)
        logEvent.success(
                Log.newBuilder().setCharacteristic(charValue.characteristic)
                        .setMessage("data write " + charValue.dataList.joinToString(", ")).build()
        )
        val isResult = bleClient.writeCharacteristic(charValue)
        result.success(isResult)
    }

    private fun readCharacteristic(call: MethodCall, result: Result) {
        val charValue = Characteristic.parseFrom(call.arguments as ByteArray)
        val isResult = bleClient.readCharacteristic(charValue)
        if (!isResult) {
            result.success(CharacteristicValue.getDefaultInstance().toByteArray())
            return
        }
        characteristicChannel.createRequest(result)
    }

    private fun setNotification(call: MethodCall, result: Result) {
        val charValue = Characteristic.parseFrom(call.arguments as ByteArray)
        val isResult = bleClient.notificationCharacteristic(charValue)
        logEvent.success(
                Log.newBuilder().setCharacteristic(charValue)
                        .setMessage("notification ${charValue.characteristicId} status bool: $isResult")
                        .build()
        )
        result.success(isResult)
    }

    private fun setIndication(call: MethodCall, result: Result) {
        val charValue = Characteristic.parseFrom(call.arguments as ByteArray)
        val isResult = bleClient.indicationCharacteristic(charValue)
//        if (isResult) {
//            logEvent.success(
//                Log.newBuilder().setCharacteristic(charValue)
//                    .setMessage("indicator ${charValue.characteristicId}").build()
//            )
//        }
        logEvent.success(
                Log.newBuilder().setCharacteristic(charValue)
                        .setMessage("indicator ${charValue.characteristicId} status bool: $isResult")
                        .build()
        )
        result.success(isResult)
    }

    private fun checkBonded(result: Result) {
        if (bleClient.isBonded) {
            result.success(true)
            return
        }
        checkBondedChannel.createRequest(result)
    }

    private fun unBonded(call: MethodCall, result: Result) {
        val model = ConnectModel.parseFrom(call.arguments as ByteArray)
        result.success(bleClient.unBonded(model.deviceId))
    }

    private fun isBluetoothAvailable(result: Result) {
        result.success(getManager(context)?.adapter?.isEnabled ?: false)
    }

    private fun isLocationAvailable(result: Result) {
        result.success(checkLocation())
    }
    //#endregion

    //region init callback sdk
    override fun locationListener(status: Boolean) {
        android.util.Log.i(BleSdkPlugin::class.simpleName, "locationListener: Location Available = $status")
//        if (status && !this::bleClient.isInitialized) {
//            initialSdk()
//        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun checkPermissionConnect(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            return ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.BLUETOOTH_CONNECT
            ) == PackageManager.PERMISSION_GRANTED
        }
        return true
    }

    override fun checkPermissionScan(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            context.checkSelfPermission(
                    Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
                    && context.checkSelfPermission(
                    Manifest.permission.BLUETOOTH_SCAN
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
        }
    }

    override fun requestPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            activity.requestPermissions(
                    arrayOf(
                            Manifest.permission.BLUETOOTH_SCAN,
                            Manifest.permission.BLUETOOTH_CONNECT,
                            Manifest.permission.ACCESS_FINE_LOCATION
                    ), 111
            )
        } else {
            activity.requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                    111
            )
        }
    }

    private fun checkLocation(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val lm: LocationManager =
                    context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
            lm.isLocationEnabled
        } else {
            @Suppress("DEPRECATION")
            val mode: Int = Settings.Secure.getInt(
                    context.contentResolver, Settings.Secure.LOCATION_MODE,
                    Settings.Secure.LOCATION_MODE_OFF
            )
            mode != Settings.Secure.LOCATION_MODE_OFF
        }
    }

    override fun enableLocation(): Boolean {
        val check = checkLocation()
        if (!check) {
            val intent = Intent(
                    Settings.ACTION_LOCATION_SOURCE_SETTINGS
            )
            activity.startActivity(intent)
        }
        return check
    }

    override fun enableBluetooth() {
        val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        if (this::activity.isInitialized) {
            ActivityCompat.startActivityForResult(activity, enableBtIntent, 1, Bundle())
        }
    }

    override fun onScanResult(result: BluetoothBLEModel) {
        if (!devices.any { it.id == result.id }) {
            scanEvent.success(result)
            devices = devices + result
        }
    }

    override fun onConnectionStateChange(state: StateConnect) {
        if (state == StateConnect.connected) {
            connectChannel.closeRequest(true)
        }
        stateConnectEvent.success(state)
    }

    override fun onServicesDiscovered(services: List<BluetoothGattService>, deviceId: String) {
        val model = Services.newBuilder()
        model.addAllServices(services.map { service ->
            Service.newBuilder().setServiceId(service.uuid.toString())
                    .addAllCharacteristics(service.characteristics.map {
                        Characteristic.newBuilder()
                                .setCharacteristicId(it.uuid.toString())
                                .setServiceId(service.uuid.toString())
                                .setDeviceId(deviceId)
                                .addAllProperties(DetectCharProperties.detect(it.properties))
                                .build()
                    }).build()
        }.toList())
        discoveredServicesChannel.closeRequest(model.build())
    }

    override fun onCharacteristicValue(
            characteristic: BluetoothGattCharacteristic,
            value: ByteArray
    ) {
        val model = CharacteristicValue.newBuilder()
        val valueListInt = value.toList().map { it.toInt().and(255) }
        model.characteristic =
                Characteristic.newBuilder().setCharacteristicId(characteristic.uuid.toString())
                        .addAllProperties(DetectCharProperties.detect(characteristic.properties))
                        .build()
        model.addAllData(valueListInt)
        characteristicEvent.success(model.build())
        characteristicChannel.closeRequest(model.build())
        logEvent.success(
                Log.newBuilder().setCharacteristic(
                        Characteristic.newBuilder().setServiceId(characteristic.service.uuid.toString())
                                .setCharacteristicId(characteristic.uuid.toString())
                                .addAllProperties(DetectCharProperties.detect(characteristic.properties))
                ).setMessage(valueListInt.joinToString(", ")).build()
        )
    }

    override fun bonded(bonded: Boolean) {
        checkBondedChannel.closeRequest(bonded)
    }

    override fun bleState(state: StateBluetooth) {
        stateBluetoothEvent.success(state)
    }
    //#endregion

    //#region override activity aware, onRequestPermissionsResult
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
//        initialSdk()
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {
        bleClient.dispose()
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ): Boolean {
        val result = requestCode == 111 && !grantResults.toList()
                .any { it != PackageManager.PERMISSION_GRANTED }
        permissionChannel.closeRequest(result)
        return result
    }
    //#endregion
}