package com.beizi.beizi_sdk.utils

import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

/*
 * Copyright © 2017 Hubcloud.com.cn. All rights reserved.
 * HashingFunctions.java
 * BeiZiSDK
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
object HashingFunctions {

    @JvmStatic
    fun md5(s: String): String {
        return hashString("MD5", s)
    }

    @JvmStatic
    fun sha1(s: String): String {
        return hashString("SHA-1", s)
    }

    private fun hashString(type: String, s: String): String {
        return try {
            val digest = MessageDigest.getInstance(type)
            digest.update(s.toByteArray())
            val messageDigest = digest.digest()
            byteToHex(messageDigest)
        } catch (e: NoSuchAlgorithmException) {
            ""
        }
    }

    private fun byteToHex(messageDigest: ByteArray): String {
        val hexString = StringBuilder()
        for (b in messageDigest) {
            val hex = Integer.toHexString(0xFF and b.toInt())
            if (hex.length == 1) {
                hexString.append('0')
            }
            hexString.append(hex)
        }
        return hexString.toString()
    }
}
