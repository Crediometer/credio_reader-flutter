import 'dart:async';

import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/credio_reader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _credioReaderPlugin = CredioReaderInitiator(
    CredioConfig(''),
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> initiateWithdrawal(BuildContext context) async {
    try {
      await _credioReaderPlugin.initiateWithdrawal(context);
    } catch (e) {
      print('Error occurred while initiating withdrawal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Credio Reader example app'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  initiateWithdrawal(context);
                },
                child: const Text('Initiate Withdrawal'),
              );
            },
          ),
        ),
      ),
    );
  }
}
