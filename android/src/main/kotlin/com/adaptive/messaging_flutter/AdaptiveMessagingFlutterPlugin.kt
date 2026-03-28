package com.adaptive.messaging_flutter

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.adaptive.messaging.AdaptiveMessaging
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

/** Flutter plugin that bridges the Adaptive Messaging Android SDK. */
class AdaptiveMessagingFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val mainHandler = Handler(Looper.getMainLooper())

    // ── FlutterPlugin ─────────────────────────────────────────────────────────

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "adaptive_messaging")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ── MethodCallHandler ─────────────────────────────────────────────────────

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {

            "setFCMToken" -> {
                val token = call.argument<String>("token")
                    ?: return result.error("INVALID_ARGUMENT", "token is required", null)
                scope.launch {
                    try {
                        AdaptiveMessaging.setFCMToken(token)
                        mainHandler.post { result.success(null) }
                    } catch (e: Exception) {
                        mainHandler.post { result.error("FCM_ERROR", e.message, null) }
                    }
                }
            }

            "isAdaptiveNotification" -> {
                val payload = call.argument<String>("payload")
                    ?: return result.error("INVALID_ARGUMENT", "payload is required", null)
                try {
                    val isAdaptive = AdaptiveMessaging.isAdaptiveNotification(payload)
                    result.success(isAdaptive)
                } catch (e: Exception) {
                    result.error("NOTIFICATION_CHECK_ERROR", e.message, null)
                }
            }

            "showAdaptiveNotification" -> {
                val payload = call.argument<String>("payload")
                    ?: return result.error("INVALID_ARGUMENT", "payload is required", null)
                try {
                    AdaptiveMessaging.showAdaptiveNotification(context, payload)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("SHOW_NOTIFICATION_ERROR", e.message, null)
                }
            }

            else -> result.notImplemented()
        }
    }
}
