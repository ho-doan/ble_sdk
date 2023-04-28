package com.hodoan.ble_sdk.channel

class CheckBondedChannel {
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
        result?.success(value)
        result = null
    }
}