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
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.ActivityCompat
import com.hodoan.ble_sdk.ProtobufModel.*
import com.hodoan.ble_sdk.ble.BleClient
import com.hodoan.ble_sdk.ble.IBleClientCallBack
import com.hodoan.ble_sdk.channel.CharacteristicChannel
import com.hodoan.ble_sdk.channel.CheckBondedChannel
import com.hodoan.ble_sdk.channel.ConnectChannel
import com.hodoan.ble_sdk.channel.DiscoveredServicesChannel
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

/** BleSdkPlugin */
class BleSdkPlugin : FlutterPlugin, MethodCallHandler, IBleClientCallBack, ActivityAware {
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

    private var devices: List<BluetoothBLEModel> = listOf()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        var manager = getManager(context)
        enableLocation()
        if (manager?.adapter?.isEnabled == false) {
            enableBluetooth()
            manager = getManager(context)
        }
        manager?.let {
            bleClient = BleClient(context, manager.adapter, this)
            bleClient.listen(context)
        }
        channel = MethodChannel(binding.binaryMessenger, "ble_sdk")
        channel.setMethodCallHandler(this)
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
            else -> result.notImplemented()
        }
    }

    //#region onMethodCall
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
        if (isResult) {
            logEvent.success(
                Log.newBuilder().setCharacteristic(charValue)
                    .setMessage("notification ${charValue.characteristicId}").build()
            )
        }
        result.success(isResult)
    }

    private fun setIndication(call: MethodCall, result: Result) {
        val charValue = Characteristic.parseFrom(call.arguments as ByteArray)
        val isResult = bleClient.indicationCharacteristic(charValue)
        if (isResult) {
            logEvent.success(
                Log.newBuilder().setCharacteristic(charValue)
                    .setMessage("indicator ${charValue.characteristicId}").build()
            )
        }
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
    //#endregion

    //region init callback sdk
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

    override fun enableLocation() {
        val check = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
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
        if (check) return
        val intent = Intent(
            Settings.ACTION_LOCATION_SOURCE_SETTINGS
        )
        activity.startActivity(intent)
    }

    override fun enableBluetooth() {
        val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        ActivityCompat.startActivityForResult(activity, enableBtIntent, 1, Bundle())
    }

    override fun onScanResult(result: BluetoothBLEModel) {
        if (!devices.any { it.id == result.id }) {
            scanEvent.success(result)
            devices = devices + result
        }
    }

    override fun onConnectionStateChange(state: StateConnect) {
        if (state == StateConnect.CONNECTED) {
            connectChannel.closeRequest(true)
        }
        stateConnectEvent.success(state)
    }

    override fun onServicesDiscovered(services: List<BluetoothGattService>) {
        val model = Services.newBuilder()
        model.addAllServices(services.map { service ->
            Service.newBuilder().setServiceId(service.uuid.toString())
                .addAllCharacteristics(service.characteristics.map {
                    Characteristic.newBuilder()
                        .setCharacteristicId(it.uuid.toString())
                        .setServiceId(service.uuid.toString())
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

    //#region override activity aware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        requestPermission()
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {
        bleClient?.dispose()
    }
    //#endregion
}
