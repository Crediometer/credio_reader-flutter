import 'package:credio_reader/components/app_selection_sheet.dart';
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
      amount: 100,
      amountInputDecoration: InputDecoration(
        labelText: 'Enter withdrawal amount',
        prefixIcon: const Icon(Icons.attach_money),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      accountTypes: [
        SelectionData(selection: 0, title: "Personal Account"),
        SelectionData(selection: 1, title: "Business Account"),
      ],
      customSelectionSheet: (BuildContext context, List<SelectionData> data,
          Function(SelectionData) onSelect) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Select Account Type'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: data
                    .map(
                      (item) => ElevatedButton(
                        child: Text(item.title!),
                        onPressed: () {
                          onSelect(item);
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      },
      customPinEntry: (BuildContext context, Function(String) onCompleted) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: TextFormField(
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: 'Enter PIN',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.length == 4) {
                onCompleted(value);
              }
            },
          ),
        );
      },
      customLoader: <T>({
        required BuildContext context,
        required Future<T> future,
        required String prompt,
        required String errorMessage,
        String? successMessage,
        VoidCallback? action,
        required Function(String) onError,
      }) async {
        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(prompt),
                  ],
                ),
              );
            },
          );

          final result = await future;

          Navigator.of(context).pop();

          if (successMessage != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text(successMessage),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }

          return result;
        } catch (error) {
          Navigator.of(context).pop();

          // Call onError to handle the error
          onError(errorMessage);

          return null;
        }
      },
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
