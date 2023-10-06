class VpnServer {
  String? hostName;
  String? iP;
  String? score;
  String? ping;
  int? speed;
  String? countryLong;
  String? countryShort;
  int? numVpnSessions;
  String? logType;
  String? operator;
  String? openVPNConfigDataBase64;

  VpnServer(
      {this.hostName,
      this.iP,
      this.score,
      this.ping,
      this.speed,
      this.countryLong,
      this.countryShort,
      this.numVpnSessions,
      this.logType,
      this.operator,
      this.openVPNConfigDataBase64});

  VpnServer.fromJson(Map<String, dynamic> json) {
    hostName = json['HostName'];
    iP = json['IP'];
    score = json['Score'].toString();
    ping = json['Ping'].toString();
    speed = json['Speed'];
    countryLong = json['CountryLong'];
    countryShort = json['CountryShort'];
    numVpnSessions = json['NumVpnSessions'];
    logType = json['LogType'];
    operator = json['Operator'];
    openVPNConfigDataBase64 = json['OpenVPN_ConfigData_Base64'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HostName'] = hostName;
    data['IP'] = iP;
    data['Score'] = score;
    data['Ping'] = ping;
    data['Speed'] = speed;
    data['CountryLong'] = countryLong;
    data['CountryShort'] = countryShort;
    data['NumVpnSessions'] = numVpnSessions;
    data['LogType'] = logType;
    data['Operator'] = operator;
    data['OpenVPN_ConfigData_Base64'] = openVPNConfigDataBase64;
    return data;
  }
}
