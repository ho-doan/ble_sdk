package com.hodoan.ble_sdk.event

import android.os.Looper
import io.flutter.plugin.common.EventChannel

class CharacteristicEvent : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    fun success(value: com.hodoan.ble_sdk.ProtobufModel.CharacteristicValue) {
        android.os.Handler(Looper.getMainLooper()).post { sink?.success(value.toByteArray()) }
    }
}