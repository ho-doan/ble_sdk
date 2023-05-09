package com.hodoan.ble_sdk.channel

import android.util.Log

class PermissionChannel {
    private var check = true
    private var result: io.flutter.plugin.common.MethodChannel.Result? = null
    fun createRequest(
        result: io.flutter.plugin.common.MethodChannel.Result
    ) {
        check = false
        this.result = result
    }

    fun closeRequest(value: Boolean) {
        if (check) return
        check = true
        try {
            result?.success(value)
            result = null
        } catch (e: java.lang.Exception) {
            Log.e(CharacteristicChannel::class.simpleName, "closeRequest: $e")
        }
    }
}