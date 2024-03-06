import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'credio_reader_platform_interface.dart';

/// An implementation of [CredioReaderPlatform] that uses method channels.
class MethodChannelCredioReader extends CredioReaderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('credio_reader');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
