package com.hodoan.ble_sdk.ble

import android.annotation.SuppressLint
import android.bluetooth.*
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.ParcelUuid
import android.util.Log
import com.hodoan.ble_sdk.ProtobufModel
import com.hodoan.ble_sdk.utils.UuidConvert
import java.lang.reflect.Method

interface IBleClient {
    fun listen(context: Context)
    fun scan(services: List<String>)
    fun stopScan()
    fun connect(deviceId: String): Boolean
    fun discoverServices(): Boolean
    fun refreshDeviceCache(gatt: BluetoothGatt?): Boolean
    fun disconnect(): Boolean
    fun readCharacteristic(serviceId: String, characteristicId: String): Boolean
    fun writeCharacteristic(serviceId: String, characteristicId: String, value: List<Int>): Boolean
    fun notificationCharacteristic(serviceId: String, characteristicId: String): Boolean
    fun unBonded(deviceId: String)
}

interface IBleClientCallBack {
    fun checkPermissionConnect(): Boolean
    fun checkPermissionScan(): Boolean
    fun requestPermission()
    fun enableLocation()
    fun enableBluetooth()
    fun onScanResult(result: ProtobufModel.BluetoothBLEModel)
    fun onConnectionStateChange(state: ProtobufModel.StateConnect)
    fun onServicesDiscovered(services: List<BluetoothGattService>)
    fun onCharacteristicValue(characteristicId: String, value: ByteArray)
    fun bonded(bonded: Boolean)
    fun bleState(state: ProtobufModel.StateBluetooth)
}

class BleClient(
    private val context: Context,
    private val adapter: BluetoothAdapter,
    private val callBack: IBleClientCallBack
) :
    IBleClient {

    @Suppress("PrivatePropertyName")
    private val TAG = BleClient::class.simpleName
    private val scanner = adapter.bluetoothLeScanner

    private val scanCallback: ScanCallback = object : ScanCallback() {
        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            when (errorCode) {
                SCAN_FAILED_ALREADY_STARTED -> {
                    Log.e(TAG, "onScanFailed: SCAN_FAILED_ALREADY_STARTED")
                }
                SCAN_FAILED_APPLICATION_REGISTRATION_FAILED -> {
                    Log.e(TAG, "onScanFailed: SCAN_FAILED_APPLICATION_REGISTRATION_FAILED")
                }
                SCAN_FAILED_FEATURE_UNSUPPORTED -> {
                    Log.e(TAG, "onScanFailed: SCAN_FAILED_FEATURE_UNSUPPORTED")
                }
                SCAN_FAILED_INTERNAL_ERROR -> {
                    Log.e(TAG, "onScanFailed: SCAN_FAILED_INTERNAL_ERROR")
                }
                else -> Log.e(TAG, "onScanFailed: UN_KNOW")
            }
        }

        @SuppressLint("MissingPermission")
        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
            result?.let {
                if (!callBack.checkPermissionConnect()) return
                if (!isScan) return
                val model = ProtobufModel.BluetoothBLEModel.newBuilder()
                model.id = it.device.address
                model.name = it.device.name
                model.bonded = it.device.bondState == BluetoothDevice.BOND_BONDED
                callBack.onScanResult(model.build())
            }
        }
    }

    private val gattCallback: BluetoothGattCallback by lazy {
        object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
                super.onConnectionStateChange(gatt, status, newState)
                when (newState) {
                    BluetoothProfile.STATE_CONNECTED -> {
                        gattCurrent = gatt
                        callBack.onConnectionStateChange(ProtobufModel.StateConnect.CONNECTED)
                    }
                    BluetoothProfile.STATE_CONNECTING -> {
                        callBack.onConnectionStateChange(ProtobufModel.StateConnect.CONNECTING)
                    }
                    BluetoothProfile.STATE_DISCONNECTING -> {
                        callBack.onConnectionStateChange(ProtobufModel.StateConnect.DISCONNECTING)
                    }
                    BluetoothProfile.STATE_DISCONNECTED -> {
                        gattCurrent = null
                        callBack.onConnectionStateChange(ProtobufModel.StateConnect.DISCONNECTED)
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
                super.onServicesDiscovered(gatt, status)
                gatt?.let {
                    callBack.onServicesDiscovered(it.services)
                }
            }

            override fun onCharacteristicRead(
                gatt: BluetoothGatt,
                characteristic: BluetoothGattCharacteristic,
                value: ByteArray,
                status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, value, status)
                callBack.onCharacteristicValue(characteristic.uuid.toString(), value)
            }

            @Suppress("DEPRECATION")
            @Deprecated("Deprecated in Java")
            override fun onCharacteristicRead(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?,
                status: Int
            ) {
                super.onCharacteristicRead(gatt, characteristic, status)
                characteristic?.let {
                    callBack.onCharacteristicValue(it.uuid.toString(), it.value)
                }
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt,
                characteristic: BluetoothGattCharacteristic,
                value: ByteArray
            ) {
                super.onCharacteristicChanged(gatt, characteristic, value)
                callBack.onCharacteristicValue(characteristic.uuid.toString(), value)
            }

            @Suppress("DEPRECATION")
            @Deprecated("Deprecated in Java")
            override fun onCharacteristicChanged(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?
            ) {
                super.onCharacteristicChanged(gatt, characteristic)
                characteristic?.let {
                    callBack.onCharacteristicValue(it.uuid.toString(), it.value)
                }
            }
        }
    }

    private var isScan = false
    private var gattCurrent: BluetoothGatt? = null
    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(p0: Context?, p1: Intent?) {
            when (p1?.action) {
                BluetoothAdapter.ACTION_STATE_CHANGED -> {
                    when (p1.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)) {
                        BluetoothAdapter.STATE_OFF -> callBack.bleState(ProtobufModel.StateBluetooth.OFF)
                        BluetoothAdapter.STATE_ON -> callBack.bleState(ProtobufModel.StateBluetooth.ON)
                        BluetoothAdapter.STATE_TURNING_OFF -> callBack.bleState(ProtobufModel.StateBluetooth.TURING_OFF)
                        BluetoothAdapter.STATE_TURNING_ON -> callBack.bleState(ProtobufModel.StateBluetooth.TURING_ON)
                    }
                }
                BluetoothDevice.ACTION_BOND_STATE_CHANGED -> {
                    when (p1.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1)) {
                        BluetoothDevice.BOND_BONDING -> callBack.bonded(false)
                        BluetoothDevice.BOND_BONDED -> callBack.bonded(true)
                        BluetoothDevice.BOND_NONE -> callBack.bonded(false)
                        else -> callBack.bonded(false)
                    }
                }
            }
        }
    }

    override fun listen(context: Context) {
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        filter.addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED)
        context.registerReceiver(receiver, filter)
    }

    override fun scan(services: List<String>) {
        stopScan()
        val filters = services.map {
            ScanFilter.Builder().setServiceUuid(ParcelUuid(UuidConvert.checkUUID(it))).build()
        }
        val scanSettings =
            ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()
        isScan = true
        @SuppressLint("MissingPermission")
        if (callBack.checkPermissionScan()) {
            scanner.startScan(filters, scanSettings, scanCallback)
        }
    }

    override fun stopScan() {
        isScan = false
        @SuppressLint("MissingPermission")
        if (callBack.checkPermissionScan()) {
            scanner.stopScan(scanCallback)
        }
    }

    @SuppressLint("MissingPermission")
    override fun connect(deviceId: String): Boolean {
        val device: BluetoothDevice? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            adapter.getRemoteLeDevice(deviceId, BluetoothDevice.ADDRESS_TYPE_PUBLIC)
        } else {
            adapter.getRemoteDevice(deviceId)
        }

        if (!callBack.checkPermissionConnect()) return false
        stopScan()
        val gatt =
            device?.connectGatt(context, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
        refreshDeviceCache(gatt)
        return gatt != null
    }

    @SuppressLint("MissingPermission")
    override fun discoverServices(): Boolean {
        if (!callBack.checkPermissionConnect()) return false
        gattCurrent?.discoverServices()
        return gattCurrent != null
    }

    override fun refreshDeviceCache(gatt: BluetoothGatt?): Boolean {
        val localGatt: BluetoothGatt = gatt ?: return false
        val localMethod = localGatt.javaClass.getMethod("refresh")
        return localMethod.invoke(localGatt) as Boolean
    }

    override fun disconnect(): Boolean {
        refreshDeviceCache(gattCurrent)
        @SuppressLint("MissingPermission")
        if (callBack.checkPermissionConnect()) {
            gattCurrent?.disconnect()
            gattCurrent?.close()
            return true
        }
        return false
    }

    override fun readCharacteristic(serviceId: String, characteristicId: String): Boolean {
        val gatt = g() ?: return gNull()
        val service = s(gatt, serviceId) ?: return sNull()
        val characteristic = c(service, characteristicId) ?: return cNull()
        @SuppressLint("MissingPermission")
        if (callBack.checkPermissionConnect()) {
            gatt.readCharacteristic(characteristic)
        }
        return false
    }

    @SuppressLint("MissingPermission")
    override fun writeCharacteristic(
        serviceId: String,
        characteristicId: String,
        value: List<Int>
    ): Boolean {
        val valueArgs = value.map { it.toByte() }.toByteArray()
        val gatt = g() ?: return gNull()
        val service = s(gatt, serviceId) ?: return sNull()
        val characteristic = c(service, characteristicId) ?: return cNull()
        notificationCharacteristic(serviceId, characteristicId)
        if (!callBack.checkPermissionConnect()) return false
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            when (gatt.writeCharacteristic(
                characteristic,
                valueArgs,
                BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            )) {
                BluetoothStatusCodes.SUCCESS -> true
                BluetoothStatusCodes.ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION -> {
                    Log.e(TAG, "writeCharacteristicT: ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION")
                    false
                }
                BluetoothStatusCodes.ERROR_GATT_WRITE_NOT_ALLOWED -> {
                    Log.e(TAG, "writeCharacteristicT: ERROR_GATT_WRITE_NOT_ALLOWED")
                    false
                }
                BluetoothStatusCodes.ERROR_UNKNOWN -> {
                    Log.e(TAG, "writeCharacteristicT: ERROR_UNKNOWN")
                    false
                }
                BluetoothStatusCodes.ERROR_GATT_WRITE_REQUEST_BUSY -> {
                    Log.e(TAG, "writeCharacteristicT: ERROR_GATT_WRITE_REQUEST_BUSY")
                    false
                }
                BluetoothStatusCodes.ERROR_PROFILE_SERVICE_NOT_BOUND -> {
                    Log.e(TAG, "writeCharacteristicT: ERROR_PROFILE_SERVICE_NOT_BOUND")
                    false
                }
                else -> {
                    Log.e(TAG, "writeCharacteristicT: UnKnown")
                    false
                }
            }
        } else {
            @Suppress("DEPRECATION")
            characteristic.value = valueArgs
            characteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            @Suppress("DEPRECATION")
            gatt.writeCharacteristic(characteristic)
        }
    }

    override fun notificationCharacteristic(serviceId: String, characteristicId: String): Boolean {
        val gatt = g() ?: return gNull()
        val service = s(gatt, serviceId) ?: return sNull()
        val characteristic = c(service, characteristicId) ?: return cNull()
        @SuppressLint("MissingPermission")
        if (callBack.checkPermissionConnect()) {
            if (gatt.setCharacteristicNotification(characteristic, true)) {
                Thread.sleep(1000)
                val descriptor = d(characteristic) ?: return dNull()
                return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    when (gatt.writeDescriptor(
                        descriptor,
                        BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                    )) {
                        BluetoothStatusCodes.SUCCESS -> true
                        BluetoothStatusCodes.ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION -> {
                            Log.e(
                                TAG,
                                "writeCharacteristicT: ERROR_MISSING_BLUETOOTH_CONNECT_PERMISSION"
                            )
                            false
                        }
                        BluetoothStatusCodes.ERROR_GATT_WRITE_NOT_ALLOWED -> {
                            Log.e(TAG, "writeCharacteristicT: ERROR_GATT_WRITE_NOT_ALLOWED")
                            false
                        }
                        BluetoothStatusCodes.ERROR_UNKNOWN -> {
                            Log.e(TAG, "writeCharacteristicT: ERROR_UNKNOWN")
                            false
                        }
                        BluetoothStatusCodes.ERROR_GATT_WRITE_REQUEST_BUSY -> {
                            Log.e(TAG, "writeCharacteristicT: ERROR_GATT_WRITE_REQUEST_BUSY")
                            false
                        }
                        BluetoothStatusCodes.ERROR_PROFILE_SERVICE_NOT_BOUND -> {
                            Log.e(TAG, "writeCharacteristicT: ERROR_PROFILE_SERVICE_NOT_BOUND")
                            false
                        }
                        else -> {
                            Log.e(TAG, "writeCharacteristicT: UnKnown")
                            false
                        }
                    }
                } else {
                    @Suppress("DEPRECATION")
                    descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                    @Suppress("DEPRECATION")
                    gatt.writeDescriptor(descriptor)
                }
            }
            return false
        }
        return false
    }

    @SuppressLint("MissingPermission")
    override fun unBonded(deviceId: String) {
        if (!callBack.checkPermissionConnect()) return
        for (device in adapter.bondedDevices.iterator()) {
            try {
                if (device.address == deviceId) {
                    val removeBond: Method = device.javaClass.getMethod("removeBond", null)
                    removeBond.invoke(device, null)
                }
            } catch (e: Exception) {
                Log.e(TAG, "unBonded: Removing has been failed: ${e.localizedMessage}")
            }
        }
    }

    private fun g(): BluetoothGatt? {
        return gattCurrent
    }

    private fun s(gatt: BluetoothGatt, serviceId: String): BluetoothGattService? {
        return gatt.getService(UuidConvert.checkUUID(serviceId))
    }

    private fun c(
        service: BluetoothGattService,
        characteristicId: String
    ): BluetoothGattCharacteristic? {
        return service.getCharacteristic(UuidConvert.checkUUID(characteristicId))
    }

    private fun d(characteristic: BluetoothGattCharacteristic): BluetoothGattDescriptor? {
        return characteristic.getDescriptor(UuidConvert.checkUUID("2902"))
    }

    private fun gNull(): Boolean {
        Log.e(TAG, "gNull: gatt is null")
        return false
    }

    private fun sNull(): Boolean {
        Log.e(TAG, "sNull: service is null")
        return false
    }

    private fun cNull(): Boolean {
        Log.e(TAG, "cNull: characteristic is null")
        return false
    }

    private fun dNull(): Boolean {
        Log.e(TAG, "dNull: descriptor is null")
        return false
    }
}