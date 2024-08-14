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
  final apiKey = "+2349090909090";

  @override
  void initState() {
    super.initState();
    _config = CredioConfig(
      apiKey,
      '2070FLRX',
      'your_webhook_url',
      companyColor: Colors.green,
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Credio Reader example app'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              _config.locator = locator<NavigationService>().navigatorKey;
              return ReaderButton(_config);
            },
          ),
        ),
      ),
    );
  }
}
