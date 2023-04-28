package com.hodoan.ble_sdk

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
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
import com.hodoan.ble_sdk.ProtobufModel.CharacteristicValue
import com.hodoan.ble_sdk.ble.BleClient
import com.hodoan.ble_sdk.ble.IBleClientCallBack
import com.hodoan.ble_sdk.channel.CharacteristicChannel
import com.hodoan.ble_sdk.channel.CheckBondedChannel
import com.hodoan.ble_sdk.channel.DiscoveredServicesChannel
import com.hodoan.ble_sdk.event.ScanResultEvent
import com.hodoan.ble_sdk.event.StateBluetoothEvent
import com.hodoan.ble_sdk.event.StateConnectEvent
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

    private val characteristicChannel = CharacteristicChannel()
    private val checkBondedChannel = CheckBondedChannel()
    private val discoveredServicesChannel = DiscoveredServicesChannel()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        var manager = getManager(context)
        enableLocation()
        if (manager?.adapter?.isEnabled == false) {
            enableBluetooth()
            manager = getManager(context)
        }
        requestPermission()
        manager?.let {
            bleClient = BleClient(context, manager.adapter, this)
            bleClient.listen(context)
        }
        channel = MethodChannel(binding.binaryMessenger, "ble_sdk")
        EventChannel(binding.binaryMessenger, "ble_sdk_scan").setStreamHandler(scanEvent)
        EventChannel(binding.binaryMessenger, "ble_sdk_connect").setStreamHandler(stateConnectEvent)
        EventChannel(binding.binaryMessenger, "ble_sdk_bluetooth").setStreamHandler(
            stateBluetoothEvent
        )
        channel.setMethodCallHandler(this)
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
            "disconnect" -> disconnect(call, result)
            "writeCharacteristic" -> writeCharacteristic(call, result)
            "readCharacteristic" -> readCharacteristic(call, result)
            "setNotification" -> setNotification(call, result)
            "checkBonded" -> checkBonded(call, result)
            "unBonded" -> unBonded(call, result)
            "isBluetoothAvailable" -> isBluetoothAvailable(result)
            else -> result.notImplemented()
        }
    }

    private fun startScan(call: MethodCall, result: Result) {
        val args = call.arguments as? Map<*, *> ?: return
        val serviceUuids =
            (args["services"] as? List<*>)?.filterIsInstance<String>()?.filter { it.isNotEmpty() }
                ?: return
        bleClient?.scan(serviceUuids)
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

    private fun connect(call: MethodCall, result: Result) {}
    private fun disconnect(call: MethodCall, result: Result) {}
    private fun writeCharacteristic(call: MethodCall, result: Result) {}
    private fun readCharacteristic(call: MethodCall, result: Result) {}
    private fun setNotification(call: MethodCall, result: Result) {}
    private fun checkBonded(call: MethodCall, result: Result) {}
    private fun unBonded(call: MethodCall, result: Result) {}
    private fun isBluetoothAvailable(result: Result) {}

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

    override fun onScanResult(result: ProtobufModel.BluetoothBLEModel) {
        scanEvent.success(result)
    }

    override fun onConnectionStateChange(state: ProtobufModel.StateConnect) {
        stateConnectEvent.success(state)
    }

    override fun onServicesDiscovered(services: List<BluetoothGattService>) {
        val model = ProtobufModel.ServicesDiscovered.newBuilder()
        model.addAllData(services.map { it.uuid.toString() }.toList())
        discoveredServicesChannel.closeRequest(model.build())
    }

    override fun onCharacteristicValue(characteristicId: String, value: ByteArray) {
        val model = CharacteristicValue.newBuilder()
        model.characteristicId = characteristicId
        model.addAllData(value.toList().map { it.toInt().and(255) })
        characteristicChannel.closeRequest(model.build())
    }

    override fun bonded(bonded: Boolean) {
        checkBondedChannel.closeRequest(bonded)
    }

    override fun bleState(state: ProtobufModel.StateBluetooth) {
        stateBluetoothEvent.success(state)
    }
    //#endregion

    //#region override activity aware
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}

    override fun onDetachedFromActivity() {}
    //#endregion
}
