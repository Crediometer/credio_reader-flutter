// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:credio_reader/components/app_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'button_configuration.dart';

class CredioConfig {
  String? terminalId;
  Map<String, dynamic>? metaData;
  late GlobalKey<NavigatorState>? locator;
  String? webhookURL;
  ButtonConfiguration? buttonConfiguration;
  Widget? initializerButton;
  double? amount;
  InputDecoration? amountInputDecoration;
  List<SelectionData>? accountTypes;
  void Function(BuildContext, List<SelectionData>, Function(SelectionData))?
      customSelectionSheet;

  Widget Function(BuildContext, Function(String))? customPinEntry;
  Future<T?> Function<T>({
    required BuildContext context,
    required Future<T> future,
    required String prompt,
    required String errorMessage,
    String? successMessage,
    VoidCallback? action,
    required Function(String) onError,
  })? customLoader;

  late String apiKey;

  CredioConfig(
    this.apiKey,
    this.terminalId,
    this.webhookURL,
    this.locator, {
    this.initializerButton,
    this.metaData,
    this.buttonConfiguration,
    this.amount,
    this.amountInputDecoration,
    this.accountTypes,
    this.customSelectionSheet,
    this.customPinEntry,
    this.customLoader,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'terminalId': terminalId,
      'apiKey': apiKey,
      'amount': amount,
    };
  }
}
