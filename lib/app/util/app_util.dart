import 'dart:math';

import 'package:flutter/material.dart';

enum ConnectionType { good, avg, bad }

class AppUtil {
  static String formatBits(int bits, int decimals) {
    if (bits <= 0) return "0 Bps";
    const suffixes = ['Bps', "Kbps", "Mbps", "Gbps", "Tbps"];
    var i = (log(bits) / log(1024)).floor();
    return '${(bits / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static ConnectionType classifyPing(int ping) {
    if (ping <= 50) return ConnectionType.good;
    if (ping <= 100) return ConnectionType.avg;
    return ConnectionType.bad;
  }

  static ConnectionType classifySpeed(int speed) {
    if (speed >= 524288000) return ConnectionType.good;
    if (speed >= 104857600) return ConnectionType.avg;
    return ConnectionType.bad;
  }

  static ConnectionType classifyConnections(int connections) {
    if (connections <= 20) return ConnectionType.good;
    if (connections <= 50) return ConnectionType.avg;
    return ConnectionType.bad;
  }

  static ThemeMode getThemeModeFromName(String modeName) {
    if (modeName == ThemeMode.light.name) return ThemeMode.light;
    if (modeName == ThemeMode.dark.name) return ThemeMode.dark;
    return ThemeMode.system;
  }
}
