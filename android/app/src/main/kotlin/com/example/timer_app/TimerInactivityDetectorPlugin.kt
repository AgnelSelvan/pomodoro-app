package com.example.timer_app

import android.app.Activity
import android.content.Context
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledExecutorService
import java.util.concurrent.TimeUnit

class TimerInactivityDetectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var lastActivityTime: Long = System.currentTimeMillis()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "inactivity_detector")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        setupActivityMonitoring()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        setupActivityMonitoring()
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun setupActivityMonitoring() {
        println("setupActivityMonitoring")
        activity?.let { activity ->
            val rootView = activity.findViewById<View>(android.R.id.content)
            rootView.setOnTouchListener { _, event ->
                when (event.action) {
                    MotionEvent.ACTION_DOWN,
                    MotionEvent.ACTION_MOVE,
                    MotionEvent.ACTION_UP -> {
                        println("Touch event detected: ACTION_UP")
                        recordUserActivity()
                        true
                    }
                    else -> false
                }
            }

        }
    }

    private fun recordUserActivity() {
        lastActivityTime = System.currentTimeMillis()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getInactivityDuration" -> {
                println("getInactivityDuration")
                val duration = getInactivityDuration()
                result.success(duration)
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    private fun getInactivityDuration(): Int {
        val currentTime = System.currentTimeMillis()
        return ((currentTime - lastActivityTime) / 1000).toInt()
    }

}