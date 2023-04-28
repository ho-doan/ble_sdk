package com.hodoan.ble_sdk.event

import io.flutter.plugin.common.EventChannel

class StateConnectEvent : EventChannel.StreamHandler {
    private var sink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    fun success(value: com.hodoan.ble_sdk.ProtobufModel.StateConnect) {
        sink?.success(value.ordinal)
    }
}