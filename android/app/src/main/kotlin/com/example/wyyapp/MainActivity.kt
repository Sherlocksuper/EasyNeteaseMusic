package com.example.wyyapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger: BinaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger()


        val channel = MethodChannel(messenger, "test")

        channel.setMethodCallHandler { call: MethodCall, result: Result ->
            if (call.method == "helloFromNativeCode") {
                result.success("hello")
            } else if (call.method == "moveTaskToBack") {
                result.success("move successful")
                moveTaskToBack(true)
            }
        }
    }

}