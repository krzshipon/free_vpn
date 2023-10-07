package com.cyclicsoft.free_vpn

import android.content.Intent
import id.superfuture.openvpn_sf_flutter.OpenVPNFlutterPlugin;
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK);
        super.onActivityResult(requestCode, resultCode, data)
    }
}
