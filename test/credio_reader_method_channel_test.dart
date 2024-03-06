import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:credio_reader/credio_reader_method_channel.dart';

void main() {
  MethodChannelCredioReader platform = MethodChannelCredioReader();
  const MethodChannel channel = MethodChannel('credio_reader');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
