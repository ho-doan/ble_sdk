package com.hodoan.ble_sdk.utils

import com.hodoan.ble_sdk.ProtobufModel.CharacteristicProperties

class DetectCharProperties {
    companion object {
        fun detect(properties: Int): List<CharacteristicProperties> {
            val p0: CharacteristicProperties? = CharacteristicProperties.forNumber(properties)
            if (p0 != null) return listOf(p0)
            val ps = CharacteristicProperties.values()
                .filter { it != CharacteristicProperties.NONE && it != CharacteristicProperties.UNRECOGNIZED }
                .map { it.number }.sortedDescending()
            var index = properties
            var lst: List<CharacteristicProperties> = listOf()
            while (index != 0) {
                for (i in ps) {
                    if (index >= i) {
                        lst = lst + CharacteristicProperties.forNumber(i)
                        index -= i
                    }
                }
            }
            return lst
        }
    }
}