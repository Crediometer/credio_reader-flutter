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
  - `apiKey` (String, required): The API key is provided to authenticate requests. It's typically the phone number you used during registration on the credio application/admin.
  - `companyColor` (Color, optional): Your company's primary color
  - `webhookUrl` (String, optional):  This is the URL where Credio will send POST requests with real-time updates about transactions and other important events. Your server should be configured to listen for POST requests at this URL. This allows your application to receive and process transaction results, connection status updates, and other relevant information asynchronously.

  Important: Ensure that your server is configured to handle POST requests at the specified URL. The webhook endpoint should be secure (HTTPS) and able to process incoming JSON payloads.
  - `metaData` (Map<String, dynamic>, optional): This parameter allows you to include additional custom data with each transaction. You can use it to pass any relevant information that you want to associate with the transaction, such as order IDs, customer information, or any other custom fields specific to your application.


  *Example of `CredioConfig` class:
  ```dart
  final CredioConfig config = CredioConfig(
    '+2349091919191',
    '2070FLRX',
    'https://webhook.site/3114981d-f591-41a0-91e7-7fb433c058b8',
    companyColor: Colors.green,
  );
  ```

2. You can also customize the company logo using the `CompanyData` class:
  - `companyLogo`(AssetImage, optional):  Your company's logo
  - `companyColor`(Color, optional):  Your company's primary color

  *Example of `CompanyData` class:
  ```dart
  CompanyData companyData = CompanyData(
    AssetImage('assets/company_logo.png'),
    Colors.blue,
  );
  ```

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
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
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

  - Successful Transaction: The callback function will return a success message, including transaction details like the    amount, timestamp, and confirmation code.
  - Failed Transaction: In case of an error or failure, the callback will include error details, allowing the app to inform the user and take appropriate actions.

## Error Handling

Error handling is crucial for a seamless user experience. The plugin provides built-in error messages, but developers can also customize how errors are handled in the callback function. Common errors include:
  - Invalid terminalId or apiKey
  - Connectivity issues with the credio reader
  - User cancellation of the transaction
 
## Deployment

Ensure that all required configurations (`terminalId`, `apiKey`) are properly set before deploying the application. The credio_reader plugin should be thoroughly tested in a staging environment to ensure it interacts correctly with the credio reader and handles transactions as expected.