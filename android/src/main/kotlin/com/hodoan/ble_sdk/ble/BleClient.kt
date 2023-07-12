package com.hodoan.ble_sdk.ble

import android.bluetooth.*
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.ParcelUuid
import android.util.Log
import com.hodoan.ble_sdk.ProtobufModel.*
import com.hodoan.ble_sdk.ble.utils.EnableNotification
import com.hodoan.ble_sdk.utils.UuidConvert
import java.lang.reflect.Method

interface IBleClient {
    fun listen(context: Context)
    fun scan(services: List<String>)
    fun stopScan()
    fun connect(connectModel: ConnectModel): Boolean
    fun discoverServices(): Boolean
    fun refreshDeviceCache(gatt: BluetoothGatt?): Boolean
    fun disconnect(): Boolean
    fun readCharacteristic(characteristic: Characteristic): Boolean
    fun writeCharacteristic(characteristic: CharacteristicValue): Boolean
    fun notificationCharacteristic(characteristic: Characteristic): Boolean
    fun indicationCharacteristic(characteristic: Characteristic): Boolean
    fun writeDescriptor(
        gatt: BluetoothGatt,
        descriptor: BluetoothGattDescriptor,
        value: ByteArray
    ): Boolean

    fun unBonded(deviceId: String): Boolean
    fun dispose()
}

interface IBleClientCallBack {
    fun checkPermissionConnect(): Boolean
    fun checkPermissionScan(): Boolean
    fun requestPermission()
    fun enableLocation()
    fun enableBluetooth()
    fun onScanResult(result: BluetoothBLEModel)
    fun onConnectionStateChange(state: StateConnect)
    fun onServicesDiscovered(services: List<BluetoothGattService>, deviceId: String)
    fun onCharacteristicValue(characteristic: BluetoothGattCharacteristic, value: ByteArray)
    fun bonded(bonded: Boolean)
    fun bleState(state: StateBluetooth)
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
    private val enableNotification = EnableNotification()

    private var scanCallback: ScanCallback = object : ScanCallback() {
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

        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            super.onScanResult(callbackType, result)
            result?.let {
                if (!callBack.checkPermissionConnect()) return
                if (!isScan) return
                Log.e(TAG, "onScanResult: ${result.device?.address}")
                val model = BluetoothBLEModel.newBuilder()
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
                        isBonded = gatt?.device?.bondState == BluetoothDevice.BOND_BONDED
                        callBack.onConnectionStateChange(StateConnect.connected)
                    }
                    BluetoothProfile.STATE_CONNECTING -> {
                        callBack.onConnectionStateChange(StateConnect.connecting)
                    }
                    BluetoothProfile.STATE_DISCONNECTING -> {
                        callBack.onConnectionStateChange(StateConnect.disconnecting)
                    }
                    BluetoothProfile.STATE_DISCONNECTED -> {
                        enableNotification.dispose()
                        isBonded = false
                        gattCurrent = null
                        callBack.onConnectionStateChange(StateConnect.disconnected)
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
                super.onServicesDiscovered(gatt, status)
                gatt?.let {
                    callBack.onServicesDiscovered(it.services, it.device.address)
                }
            }


            override fun onCharacteristicRead(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?,
                status: Int
            ) {
                if (status != BluetoothGatt.GATT_SUCCESS) {
                    gatt?.device?.createBond()
                }
                characteristic?.let {
                    callBack.onCharacteristicValue(it, it.value ?: byteArrayOf())
                }
                super.onCharacteristicRead(gatt, characteristic, status)
            }

            override fun onCharacteristicChanged(
                gatt: BluetoothGatt?,
                characteristic: BluetoothGattCharacteristic?
            ) {
                characteristic?.let {
                    callBack.onCharacteristicValue(it, it.value)
                }
                super.onCharacteristicChanged(gatt, characteristic)
            }
        }
    }

    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(p0: Context?, p1: Intent?) {
            when (p1?.action) {
                BluetoothAdapter.ACTION_STATE_CHANGED -> {
                    when (p1.getIntExtra(
                        BluetoothAdapter.EXTRA_STATE,
                        BluetoothAdapter.ERROR
                    )) {
                        BluetoothAdapter.STATE_OFF -> callBack.bleState(StateBluetooth.off)
                        BluetoothAdapter.STATE_ON -> callBack.bleState(StateBluetooth.on)
                        BluetoothAdapter.STATE_TURNING_OFF -> callBack.bleState(StateBluetooth.turningOff)
                        BluetoothAdapter.STATE_TURNING_ON -> callBack.bleState(StateBluetooth.turningOn)
                        else -> callBack.bleState(StateBluetooth.notSupport)
                    }
                }
                BluetoothDevice.ACTION_BOND_STATE_CHANGED -> {
                    when (p1.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1)) {
                        BluetoothDevice.BOND_BONDING -> {
//                            callBack.bonded(false)
//                            isBonded = false
                        }
                        BluetoothDevice.BOND_BONDED -> {
                            callBack.bonded(true)
                            isBonded = true
                        }
                        BluetoothDevice.BOND_NONE -> {
                            callBack.bonded(false)
                            isBonded = false
                        }
                        else -> {
                            callBack.bonded(false)
                            isBonded = false
                        }
                    }
                }
            }
        }
    }

    private var isScan = false
    var isBonded = false
    private var gattCurrent: BluetoothGatt? = null

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
        if (!callBack.checkPermissionScan()) return
        scanner.startScan(filters, scanSettings, scanCallback)
    }

    override fun stopScan() {
        isScan = false
        if (callBack.checkPermissionScan()) {
            scanner.flushPendingScanResults(scanCallback)
            scanner.stopScan(scanCallback)
        }
    }

    override fun connect(connectModel: ConnectModel): Boolean {
        val device = adapter.getRemoteDevice(connectModel.deviceId)

        if (!callBack.checkPermissionConnect()) return false
        stopScan()
        if (connectModel.createBonded) {
            device?.createBond()
        }
        val gatt =
            device?.connectGatt(context, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
        refreshDeviceCache(gatt)
        isBonded = device?.bondState == BluetoothDevice.BOND_BONDED
        return gatt != null
    }

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
        isBonded = false
        refreshDeviceCache(gattCurrent)
        if (!callBack.checkPermissionConnect()) return false
        gattCurrent?.disconnect()
        gattCurrent?.close()
        return true
    }

    override fun readCharacteristic(characteristic: Characteristic): Boolean {
        val gatt = g() ?: return gNull()
        val service = s(gatt, characteristic.serviceId) ?: return sNull()
        val gattCharacteristic = c(service, characteristic.characteristicId) ?: return cNull()
        if (callBack.checkPermissionConnect()) {
            return gatt.readCharacteristic(gattCharacteristic)
        }
        return false
    }

    override fun writeCharacteristic(
        characteristic: CharacteristicValue
    ): Boolean {
        val valueArgs = characteristic.dataList.map { it.toByte() }.toByteArray()
        val gatt = g() ?: return gNull()
        val service = s(gatt, characteristic.characteristic.serviceId) ?: return sNull()
        val gattCharacteristic =
            c(service, characteristic.characteristic.characteristicId) ?: return cNull()
        if (!callBack.checkPermissionConnect()) return false
        gattCharacteristic.value = valueArgs
        gattCharacteristic.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
        Thread.sleep(150L)
        return gatt.writeCharacteristic(gattCharacteristic)
    }

    override fun notificationCharacteristic(characteristic: Characteristic): Boolean {
        val gatt = g() ?: return gNull()
        val service = s(gatt, characteristic.serviceId) ?: return sNull()
        val gattCharacteristic = c(service, characteristic.characteristicId) ?: return cNull()
        if (!callBack.checkPermissionConnect()) return false
        if (enableNotification.enable(characteristic)) {
            if (!gatt.setCharacteristicNotification(gattCharacteristic, true))
                return false
            else Thread.sleep(1000L)
        }
        val descriptor = d(gattCharacteristic) ?: return dNull()
        return writeDescriptor(gatt, descriptor, BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE)
    }

    override fun indicationCharacteristic(characteristic: Characteristic): Boolean {
        val gatt = g() ?: return gNull()
        val service = s(gatt, characteristic.serviceId) ?: return sNull()
        val gattCharacteristic = c(service, characteristic.characteristicId) ?: return cNull()
        if (!callBack.checkPermissionConnect()) return false
        if (enableNotification.enable(characteristic)) {
            if (!gatt.setCharacteristicNotification(gattCharacteristic, true))
                return false
            else Thread.sleep(1000L)
        }
        val descriptor = d(gattCharacteristic) ?: return dNull()
        return writeDescriptor(gatt, descriptor, BluetoothGattDescriptor.ENABLE_INDICATION_VALUE)
    }

    override fun writeDescriptor(
        gatt: BluetoothGatt,
        descriptor: BluetoothGattDescriptor,
        value: ByteArray
    ): Boolean {
        descriptor.value = value
        return gatt.writeDescriptor(descriptor)
    }

    override fun unBonded(deviceId: String): Boolean {
        isBonded = false
        if (!callBack.checkPermissionConnect()) return false
        for (device in adapter.bondedDevices.iterator()) {
            try {
                if (device.address == deviceId) {
                    val removeBond: Method = device.javaClass.getMethod("removeBond", null)
                    removeBond.invoke(device, null)
                    return true
                }
            } catch (e: Exception) {
                Log.e(TAG, "unBonded: Removing has been failed: ${e.localizedMessage}")
                return false
            }
        }
        return true
    }

    override fun dispose() {
        disconnect()
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