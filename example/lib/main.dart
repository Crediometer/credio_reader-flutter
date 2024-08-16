import 'package:credio_reader/configuration/button_configuration.dart';
import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/credio_reader.dart';
import 'package:credio_reader_example/nav.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}

void main() async {
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final CredioConfig _config;
  final apiKey =
      'your_api_key'; //example: tracker_cred_8f3X9pLm2qRt7vYw4hNk6bJc
  final webHookUrl = 'your_webHook_url';

  @override
  void initState() {
    super.initState();
    _config = CredioConfig(
      apiKey,
      '2070FLRX',
      webHookUrl,
      locator<NavigationService>().navigatorKey,
      initializerButton: Text("I can use a single Text"),
      buttonConfiguration: ButtonConfiguration(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                15.0,
              ),
            ),
          ),
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Credio Reader example app'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return ReaderButton(_config);
            },
          ),
        ),
      ),
    );
  }
}
