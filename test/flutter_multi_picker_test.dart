import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_multi_picker/flutter_multi_picker.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_multi_picker');

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
    // expect(await FlutterMultiPicker.platformVersion, '42');
  });
}
