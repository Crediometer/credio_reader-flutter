// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CredioConfig {
  String? terminalId;
  Color? companyColor;
  Map<String, dynamic>? metaData;
  late GlobalKey<NavigatorState>? locator;
  String? webhookURL;

  late String apiKey;

  CredioConfig(
    this.apiKey,
    this.terminalId,
    this.webhookURL, {
    this.locator,
    this.metaData,
    this.companyColor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'terminalId': terminalId,
      'apiKey': apiKey,
    };
  }
}
