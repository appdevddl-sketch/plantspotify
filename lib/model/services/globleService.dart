import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/object_extension.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class GlobalService extends GetxService {

  Future<GlobalService> init() async {
    return this;
  }

  Future<String> getFireBaseToken() async {
    String firebaseToken = "";
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (Get
        .find<AuthService>()
        .firebaseToken
        .value
        .isEmpty) {
      try {
        await messaging.getToken().then((token) {
          'firebase token : $token'.printLog();
          firebaseToken = token ?? "";
        });
      } catch (e) {
        e.printError();
      }
    } else {
      try {
        firebaseToken = Get
            .find<AuthService>()
            .firebaseToken
            .value ?? '';
      } catch (e) {
        e.printError();
      }
    }
    return firebaseToken ?? "";
  }

  Future<String> getEncryptedToken(String data) async {
    List<int> bytes = utf8.encode(data);
    Digest sha256Hash = sha256.convert(bytes);
    return sha256Hash.toString();
  }
  Future<File> assetToFile(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    List<int> imageData = byteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/temp_image_${DateTime.now().millisecondsSinceEpoch}.png';
    File file = File(tempPath);
    await file.writeAsBytes(imageData);
    ("file :: =>> $file").logPrint();

    //// this code  is to check whether the saved image is stored in the temp directory or not .
    final exists = await File(file.path).exists();
    if (exists) {
      ('File exists at: ${file.path}').logPrint();
    } else {
      ('File NOT found at: ${file.path}').logPrint();
    }
    return file;
  }
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      ("Unique Id For Android :${androidDeviceInfo.id} ").logPrint;
      return androidDeviceInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      ("Unique Id For iOS :${iosDeviceInfo.identifierForVendor} ").logPrint();
      return iosDeviceInfo.identifierForVendor ?? "";
    }
    return "";
  }

}