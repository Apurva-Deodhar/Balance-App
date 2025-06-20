package com.example.homepage
package com.example.homepage

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.homepage/auth"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getWebClientId") {
                // Correctly fetch the web client ID from the strings.xml file
                val webClientId = getString(R.string.web_client_id)
                result.success(webClientId)
            } else {
                result.notImplemented()
            }
        }
    }
}

