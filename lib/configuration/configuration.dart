// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

class CredioConfig {
  bool? directDebit;
  String? terminalId;
  String? companyLogo;
  Color? companyColor;
  late GlobalKey<NavigatorState>? locator;

  late String apiKey;

  CredioConfig(
    this.apiKey, {
    this.locator,
    this.directDebit = false,
    this.terminalId,
    this.companyColor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'directDebit': directDebit,
      'terminalId': terminalId,
      'apiKey': apiKey,
    };
  }
}
