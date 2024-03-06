import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'credio_reader_method_channel.dart';

abstract class CredioReaderPlatform extends PlatformInterface {
  /// Constructs a CredioReaderPlatform.
  CredioReaderPlatform() : super(token: _token);

  static final Object _token = Object();

  static CredioReaderPlatform _instance = MethodChannelCredioReader();

  /// The default instance of [CredioReaderPlatform] to use.
  ///
  /// Defaults to [MethodChannelCredioReader].
  static CredioReaderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CredioReaderPlatform] when
  /// they register themselves.
  static set instance(CredioReaderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
