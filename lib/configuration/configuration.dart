// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

class CredioConfig {
  bool? directDebit;
  String? terminalId;
  String? companyLogo;
  Color? companyColor;

  late String apiKey;

  CredioConfig(this.apiKey, {this.directDebit = false, this.terminalId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'directDebit': directDebit,
      'terminalId': terminalId,
      'apiKey': apiKey,
    };
  }

  factory CredioConfig.fromMap(Map<String, dynamic> map) {
    return CredioConfig(
      map['apiKey'] as String,
      directDebit:
          map['directDebit'] != null ? map['directDebit'] as bool : null,
      terminalId:
          map['terminalId'] != null ? map['terminalId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CredioConfig.fromJson(String source) =>
      CredioConfig.fromMap(json.decode(source) as Map<String, dynamic>);
}
