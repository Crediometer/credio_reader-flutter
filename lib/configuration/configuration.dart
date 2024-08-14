// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'button_configuration.dart';

class CredioConfig {
  String? terminalId;
  Map<String, dynamic>? metaData;
  late GlobalKey<NavigatorState>? locator;
  String? webhookURL;
  ButtonConfiguration? buttonConfiguration;
  Widget? initializerButton;

  late String apiKey;

  CredioConfig(
    this.apiKey,
    this.terminalId,
    this.webhookURL,
    this.locator, {
    this.initializerButton,
    this.metaData,
    this.buttonConfiguration,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'terminalId': terminalId,
      'apiKey': apiKey,
    };
  }
}
