package com.hodoan.ble_sdk.channel

import io.flutter.plugin.common.MethodChannel.Result

class ConnectChannel {
    private var check = true
    private var result: Result? = null
    fun createRequest(
        result: Result
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