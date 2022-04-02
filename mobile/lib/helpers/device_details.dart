import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

// Get device details using package
Future<Map> getDeviceDetails() async {
  var phoneInfo = {};

  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    phoneInfo['os'] = 'ios';
    phoneInfo['id'] = iosDeviceInfo.identifierForVendor;
    phoneInfo['brand'] = iosDeviceInfo.name;
    phoneInfo['model'] = iosDeviceInfo.model;
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    phoneInfo['os'] = 'android';
    phoneInfo['id'] = androidDeviceInfo.androidId;
    phoneInfo['brand'] = androidDeviceInfo.brand;
    phoneInfo['model'] = androidDeviceInfo.model;
  }

  return phoneInfo;
}