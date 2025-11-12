package com.beizi.beizi_sdk.utils

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import android.text.TextUtils
import android.widget.Toast
import java.io.*
import java.text.SimpleDateFormat
import java.util.*

/**
 * Created by LY on 2016/10/10.14:07
 * 版权所有 盗版必究
 * 文件工具类
 */
object FileUtil {
    /**
     * 项目根目录
     */
    private const val APP_DIR = "Beizi"

    @JvmStatic
    fun getSdkDownloadFile(context: Context): File? {
        val storagePath = getFilesDirectory(context)
        return storagePath?.let {
            val path = "${it.path}/Beizi/download/"
            val dir = File(path)
            if (!dir.exists()) {
                dir.mkdirs()
            }
            dir
        }
    }

    /**
     * 获取sd卡下项目目录
     */
    private fun getAppDir(): File? {
        // This method was commented out in the original Java file and returns null.
        // Preserving the original logic.
        return null
    }

    /**
     * 获取项目根目录下指定的子目录
     */
    private fun getDir(dirName: String): File {
        val dir = File(getAppDir(), dirName)
        if (!dir.exists()) {
            dir.mkdirs()
        }
        return dir
    }

    /**
     * 删除缓存文件
     */
    @JvmStatic
    fun deleteCacheFile(dir: File, rename: String) {
        val target = File(dir, rename)
        if (target.exists()) {
            target.delete()
        }
    }

    /**
     * 判断应用是否已安装
     */
    @JvmStatic
    fun checkApkInstalled(context: Context, packageName: String?): Boolean {
        if (packageName.isNullOrEmpty()) {
            return false
        }
        return try {
            context.packageManager.getApplicationInfo(packageName, 0) != null
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    /**
     * 启动应用
     */
    @JvmStatic
    fun startApp(context: Context, packageName: String) {
        try {
            val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
            launchIntent?.let {
                it.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                context.startActivity(it)
            }
        } catch (e: ActivityNotFoundException) {
            Toast.makeText(context, "启动失败:$packageName", Toast.LENGTH_LONG).show()
        }
    }

    /**
     * 创建保存的文件夹
     */
    @JvmStatic
    fun createDirDirectory(downloadPath: String) {
        val dirDirectory = File(downloadPath)
        if (!dirDirectory.exists()) {
            dirDirectory.mkdirs()
        }
    }

    @JvmStatic
    fun getFilesDirectory(context: Context?): File? {
        if (context == null) return null
        return try {
            if (Build.VERSION.SDK_INT >= 19) {
                var file: File? = null
                // 外部存储可用
                if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState() || !Environment.isExternalStorageRemovable()) {
                    file = context.getExternalFilesDir(null)
                }
                // 外部存储不可用, or file is null
                file ?: context.filesDir
            } else {
                context.filesDir
            }
        } catch (e: Exception) {
            context.filesDir
        }
    }

    @JvmStatic
    fun getCacheDirectory(context: Context): File {
        var appCacheDir: File? = null
        if (Build.VERSION.SDK_INT >= 19) {
            // This was commented out in the original, maintaining that logic.
            // if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState() || !Environment.isExternalStorageRemovable()) {
            //     appCacheDir = context.externalCacheDir
            // }
            if (appCacheDir == null) {
                appCacheDir = context.cacheDir
            }
        } else {
            appCacheDir = context.cacheDir
            if (appCacheDir == null) {
                val cacheDirPath = "/data/data/${context.packageName}/cache/"
                appCacheDir = File(cacheDirPath)
            }
        }
        return appCacheDir
    }

    @JvmStatic
    fun getResourceCacheDirectory(context: Context): File {
        var appCacheDir: File? = null
        if (Build.VERSION.SDK_INT >= 19) {
            if (appCacheDir == null) {
                val path = "${context.cacheDir.path}/beizi/material/"
                appCacheDir = File(path)
                if (!appCacheDir.exists()) {
                    appCacheDir.mkdirs()
                }
            }
        } else {
            appCacheDir = context.cacheDir
            if (appCacheDir == null) {
                val cacheDirPath = "/data/data/${context.packageName}/cache/beizi/material/"
                appCacheDir = File(cacheDirPath)
                if (!appCacheDir.exists()) {
                    appCacheDir.mkdirs()
                }
            }
        }
        return appCacheDir
    }

    /**
     * 删除过期文件
     */
    @JvmStatic
    fun deleteOldFiles(context: Context) {
        try {
            val directory = getResourceCacheDirectory(context)
            if (directory.exists()) {
                val files = directory.listFiles()
                files?.let {
                    val dateFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault())
                    val fifteenDaysAgo = Date(System.currentTimeMillis() - 15 * 24 * 60 * 60 * 1000)
                    for (file in it) {
                        if (file.isFile) {
                            try {
                                val creationTime = dateFormat.parse(dateFormat.format(Date(file.lastModified())))
                                if (creationTime != null && creationTime.before(fifteenDaysAgo)) {
                                    file.delete()
                                }
                            } catch (e: Exception) {
                                e.printStackTrace()
                            }
                        }
                    }
                }
            }
        } catch (t: Throwable) {
            t.printStackTrace()
        }
    }

    @JvmStatic
    fun getAdCacheDirectory(context: Context): File {
        var appCacheDir: File?
        val path = "${context.cacheDir.path}/beizi/ad/"
        appCacheDir = File(path)
        if (!appCacheDir.exists()) {
            appCacheDir.mkdirs()
        }
        return appCacheDir
    }

    /**
     * 写字符串到文件中
     */
    @JvmStatic
    fun writeContentToFile(context: Context?, folderName: String?, fileName: String?, content: String?): Boolean {
        if (context == null || folderName.isNullOrEmpty() || fileName.isNullOrEmpty() || content.isNullOrEmpty()) {
            return false
        }
        try {
            val storagePath = getAdCacheDirectory(context)
            val path = "${storagePath.path}/$folderName/"
            val dir = File(path)
            if (!dir.exists()) {
                dir.mkdirs()
            }
            val file = File(dir, fileName)
            file.bufferedWriter().use { it.write(content) }
            return true
        } catch (e: Throwable) {
            e.printStackTrace()
            return false
        }
    }
}
