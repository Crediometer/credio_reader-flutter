# Credio Reader Plugin

## Introduction

The `Credio Reader` plugin is a Flutter package designed to simplify the integration of Credio payment terminals into your mobile application. It provides a customizable button that manages the connection to a Credio reader and initiates payment transactions.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  credio_reader: ^latest_version
```
Then, run `flutter pub get` in your terminal to install the package.

## Configuration

1. The plugin uses the `CredioConfig` class for configuration. Here's how to set it up:
  - `terminalId` (String, required): The unique identifier for the terminal where the transaction will take place.
 - `apiKey` (String, required): The API key used to authenticate requests. This key is generated when you sign up on the Credio TrackMoney platform (https://trackmoney.crediometer.com/). The API key format is similar to `tracker_cred_8f3X9pLm2qRt7vYw4hNk6bJc`. Follow the registration process on the TrackMoney platform to obtain your unique API key.
  **Note: The API key is no longer the phone number used for registration. Make sure to update your integration to use the new API key format.
  - `locator` (GlobalKey<NavigatorState>, required): A GlobalKey for the NavigatorState, used for navigation within the plugin.
  - `companyColor` (Color, optional): Your company's primary color
  - `webhookUrl` (String, optional):  This is the URL where Credio will send POST requests with real-time updates about transactions and other important events. Your server should be configured to listen for POST requests at this URL. This allows your application to receive and process transaction results, connection status updates, and other relevant information asynchronously.
  Important: Ensure that your server is configured to handle POST requests at the specified URL. The webhook endpoint should be secure (HTTPS) and able to process incoming JSON payloads.
  - `metaData` (Map<String, dynamic>, optional): This parameter allows you to include additional custom data with each transaction. You can use it to pass any relevant information that you want to associate with the transaction, such as order IDs, customer information, or any other custom fields specific to your application.
  - `initializerButton` (Widget, optional): A custom widget to be used as the initializer button.
  - `buttonConfiguration` (ButtonConfiguration, optional): Configuration for customizing the appearance of the ReaderButton.
  - `amount` (double, optional): A predefined amount for the transaction. If set, the amount input textbox will be not be shown.
  - `amountInputDecoration` (InputDecoration, optional): Custom decoration for the amount input field.
  - `accountTypes` (List<SelectionData>, optional): Custom list of account types for selection.
  - `customSelectionSheet` (Function, optional): Custom implementation for the account type selection sheet.
  - `customPinEntry` (Function, optional): Custom implementation for the PIN entry widget.
  - `customLoader` (Function, optional): Custom implementation for the loading and error handling during transactions.



  *Example of `CredioConfig` class:
  ```dart
  final GetIt locator = GetIt.instance;

  void setupLocator() {
    locator.registerLazySingleton(() => NavigationService());
  }

  final apiKey =
      'your_api_key'; //example: tracker_cred_8f3X9pLm2qRt7vYw4hNk6bJc
  final webHookUrl = 'your_webHook_url';

  final CredioConfig config = CredioConfig(
      apiKey,
      '2070FLRX',
      webHookUrl,
      locator<NavigationService>().navigatorKey,
      initializerButton: const Text("I can use a single Text"),
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
      amountInputDecoration: InputDecoration(
        labelText: 'Enter withdrawal amount',
        prefixIcon: const Icon(Icons.attach_money),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      customSelectionSheet: (BuildContext context, List<SelectionData> data,
          Function(SelectionData) onSelect) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Account Type'),
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
            decoration: const InputDecoration(
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
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(prompt),
                  ],
                ),
              );
            },
          );

          final result = await future;

          if (context.mounted) Navigator.of(context).pop();

          if (successMessage != null) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Success'),
                    content: Text(successMessage),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }

          return result;
        } catch (error) {
          if (context.mounted) Navigator.of(context).pop();

          // Call onError to handle the error
          onError(errorMessage);

          return null;
        }
      },
);```

### Predefined Account Types
The plugin now uses predefined account types. These are:

- Universal (selection: 0)
- Savings (selection: 1)
- Current (selection: 2)
- Credit (selection: 3)

These account types are used in the account selection process. If you're implementing a custom selection UI, make sure to use these predefined types.

Note: For detailed usage of these new customization options, please refer to the example app in the package repository.

## Permissions

Before using the ReaderButton in your app, ensure that you have requested and received the necessary permissions. The Credio Reader plugin requires the following permissions:

- Bluetooth
- Internet
- Location (for Android)

 ### Platform Specific Setup
  To ensure your app can request these permissions, add the following to your app's configuration files:

Android:
In your `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- For Android 12 and above -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```

IOS:
In your `Info.plist`:

```xml
<key>NSBluetoothPeripheralUsageDescription</key>
<string>We need access to Bluetooth to connect to credio reader and provide you with pos payment functionality.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Credio would like to access your location to provide you with relevant and personalized services. Your location information will only be used while you are using the app.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Credio requires Bluetooth access to securely connect to the Credio reader and facilitate seamless communication for payment processing and device configuration.</string>
```


You should request these permissions before initializing the ReaderButton. Here's a simple example of how to do this:
```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCredioPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.location,
  ].request();

  return statuses[Permission.bluetooth]!.isGranted && 
         statuses[Permission.location]!.isGranted;
}

// Usage in your app
void initializeCredioReader() async {
  if (await requestCredioPermissions()) {
    // Permissions granted, you can now use ReaderButton
    // For example:
    // ReaderButton(_config)
  } else {
    // Handle the case where permissions are not granted
    // You might want to show a dialog explaining why the permissions are needed
  }
}
```


## Usage

After creating your `CredioConfig` instance as described in the Configuration section, you can use the Credio Reader in your app by adding the `ReaderButton` widget to your UI:
```
ReaderButton(config)
```

## Transaction Handling

The transaction process is initiated when the user presses the custom Credio button. The plugin manages the interaction with the credio reader and handles the transaction in the background. Upon completion, the callback function is triggered, providing the result of the transaction.

  - Successful Transaction: The callback function will return a success message, including transaction details like the amount, timestamp, and reponse code. A transaction is only considered successful if the responseCode is “00"
  - Failed Transaction: In case of an error or failure, the callback will include error details, allowing the app to inform the user and take appropriate actions.

## Error Handling

Error handling is crucial for a seamless user experience. The plugin provides built-in error messages, but developers can also customize how errors are handled in the callback function. Common errors include:
  - Invalid terminalId or apiKey
  - Connectivity issues with the credio reader
  - User cancellation of the transaction
 
## Deployment

Ensure that all required configurations (`terminalId`, `apiKey`) are properly set before deploying the application. The credio_reader plugin should be thoroughly tested in a staging environment to ensure it interacts correctly with the credio reader and handles transactions as expected.