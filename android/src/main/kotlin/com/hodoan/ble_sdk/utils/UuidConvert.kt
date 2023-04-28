package com.hodoan.ble_sdk.utils

import android.nfc.FormatException
import java.nio.ByteBuffer
import java.util.*

class UuidConvert {
    companion object {
        private fun convert128BitNotationToUuid(bytes: ByteArray): UUID {
            val bb = ByteBuffer.wrap(bytes)
            val most = bb.long
            val least = bb.long
            return UUID(most, least)
        }

        fun checkUUID(strUUID: String): UUID {
            return if (strUUID.length == 4) {
                convert16BitToUuid(strUUID)
            } else {
                return try {
                    UUID.fromString(strUUID)
                } catch (e: java.lang.Exception) {
                    throw FormatException("UUID: $strUUID is format valid")
                }
            }
        }

        private fun convert16BitToUuid(uuid: String): UUID {
            val bytes = fromString(uuid)
            val uuidConstruct = byteArrayOf(
                0x00, 0x00, bytes[0], bytes[1], 0x00, 0x00, 0x10, 0x00,
                0x80.toByte(), 0x00, 0x00, 0x80.toByte(), 0x5F, 0x9B.toByte(), 0x34, 0xFB.toByte()
            )
            return convert128BitNotationToUuid(uuidConstruct)
        }

        private fun fromString(str: String): ByteArray {
            return str.lowercase().chunked(2).map { it.toInt(16).toByte() }.toByteArray()
        }
    }
}