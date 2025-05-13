import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const MethodChannel channel = MethodChannel(
  'dev.fluttercommunity.plus/package_info',
);

Future<void> configureMockPackageInfo({required String packageName}) async {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{
            'appName': 'Storyzz',
            'packageName': packageName,
            'version': '0.1.0',
            'buildNumber': '2',
          };
        }
        return null;
      });
}
