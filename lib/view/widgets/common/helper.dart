

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/app_constants.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/utils/download_file_util.dart';
import '../../../model/utils/package_info_util.dart';
import '../toast_view/showtoast.dart';

class HelperFunction {
  static Future<dynamic> getJsonFile(String path) async {
    return await rootBundle.loadString(path).then((v)=>jsonDecode(v));
  }

  static bool appTranslationSide()  {
    return Get.locale.toString()=="ar";
  }
  static String dateExtract(String dateTimeString){
      DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
  static void  onDownloadStatementDoc(String link,String filename) {
    String fileExtension = path.extension(link);
    // print('File extension: $fileExtension'); // Output extension of file
    late final DownloadUtil statementDownloadUtils = DownloadUtil(onStart: (){
      toastShow(message: "${"Download started".tr}...", error: false);
    },
        onComplete: () async {
          // toastShow(message: "Download started...", error: false);

          toastShow(message: "${filename.tr} ${"has been downloaded successfully in your device's".tr} ${Platform.isIOS ? PackageInfoUtil.instance.appName : 'Download'.tr} ${'folder'.tr}.", error: false,);

          // toastShow(
          //     message: "${filename=='Invoice'?'Invoice':'Prescription'}has been downloaded successfully in your device's".tr ${Platform.isIOS ? PackageInfoUtil.instance.appName : 'Download'.tr} ${"folder".tr}."
          //     , error: false);

        }, onError: (){
          toastShow(message: "${"Error while downloading file".tr}...", error: true);

        });
    statementDownloadUtils.createFolderAndDownloadFile(url: link, fileNameWithExtensions:'$filename${(Random().nextInt(10000 - 200 + 1) + 200??'ODR')}${filename=='Invoice'?'.pdf':fileExtension}' ,isShowNotification: false);
  }

  static String formatDate(String date){
    if(date.isNotEmpty){
      DateTime dateTime = DateTime.parse(date);
      return "${DateFormat('yyyy-MM-dd').format(dateTime)} , ${DateFormat('hh:mm a').format(dateTime)}";
    }else{
      return "";
    }
  }
  String formatToAmPm(String time) {
    try {
      final dateTime = DateFormat("HH:mm").parse(time); // Parse 24-hour format.
      return DateFormat("hh:mm a").format(dateTime);    // Convert to 12-hour format.
    } catch (e) {
      return time; // Return the original string if parsing fails.
    }
  }
  static String formatFullDateTime(String date) {
    if (date.isEmpty) return "";

    try {
      DateTime dateTime = DateTime.parse(date).toLocal();

      // return "${DateFormat('d MMMM yyyy').format(dateTime)}, "
      //     "${DateFormat('hh:mm a').format(dateTime)}";
      return DateFormat('d MMMM, yyyy').format(dateTime);
    } catch (e) {
      return "";
    }
  }
  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }
  static String formatTime(dynamic timestamp) {
    if (timestamp == null) {
      return "";
    }
    DateTime dateTime;

    if (timestamp is DateTime) {
      dateTime = timestamp;
    }
    else if (timestamp is String) {
      try {
        dateTime = DateTime.parse(timestamp);
      } catch (e) {
        return "";
      }
    }
    else {
      throw ArgumentError("Invalid timestamp format: $timestamp");
    }
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatChatDate(DateTime timestamp) {
    return DateFormat("d MMMM, yyyy").format(timestamp);
  }
  // String base64ToDataUrl(String base64ImageData) {
  //
  //   List<String> parts = base64ImageData.split(",");
  //   String mimeType = parts.first.contains("image/") ? parts.first : "image/png";
  //   String base64String = parts.last;
  //   return "data:$mimeType;base64,$base64String";
  // }
  static String getHashData(String conCateString) {
    ("HASH DATA ::::::::::::::=>$conCateString").logPrint();
    Digest hash = md5.convert(utf8.encode(conCateString));
    // ("HASH_STRING::${hash.toString()}").logPrint;
    return hash.toString();
  }
  static String formatDateForHash(){
   return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(DateTime.now());
  }
  static Color hexStringToColor(String hexColor) {
    if(hexColor.isEmpty){
      return ColorResource.instance.white;
    }else{
      return Color(int.parse(hexColor));
    }


  }
  static void prd(dynamic value ) {
    ("PRD:::::::=>${value.toString()}").logPrint();
  }

  static Future shareApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appStoreID = "6757214372";

    final playStoreLink =
        'https://play.google.com/store/apps/details?id=$packageName';

    final appStoreLink =
        'https://apps.apple.com/app/id$appStoreID';

    final message =
        'Identify plants instantly and diagnose diseases with PlantSpotify! 🌿📷 '
        'Scan plants, get insights, and manage your nursery easily. '
        'Download now and keep your plants healthy! 🌱';

    final shareText = Platform.isIOS
        ? '$message\n$appStoreLink'
        : '$message\n$playStoreLink';

    await SharePlus.instance.share(
      ShareParams(text: shareText),
    );
  }
  static Future<void> openStoreListing() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;
      String appStoreID = "6757214372";

      Uri url;

      if (Platform.isAndroid) {
        url = Uri.parse('market://details?id=$packageName');
      } else {
        url = Uri.parse('https://apps.apple.com/app/id$appStoreID');
      }

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        final fallbackUrl = Platform.isAndroid
            ? Uri.parse('https://play.google.com/store/apps/details?id=$packageName')
            : Uri.parse('https://apps.apple.com/app/id$appStoreID');
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error launching store: $e');
    }
  }

  static Future<void> openStoreForRating() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String packageName = packageInfo.packageName;


      String appStoreID = "6757214372";

      Uri url;

      if (Platform.isAndroid) {

        url = Uri.parse('market://details?id=$packageName');
      } else {

        url = Uri.parse(
          'https://apps.apple.com/app/id$appStoreID?action=write-review',
        );
      }

      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to HTTPS if market:// fails
        final fallbackUrl = Platform.isAndroid
            ? Uri.parse(
            'https://play.google.com/store/apps/details?id=$packageName')
            : Uri.parse('https://apps.apple.com/app/id$appStoreID');

        await launchUrl(
          fallbackUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Error launching store: $e');
    }
  }

  Future<List<Permission>> requiredPermissions() async {
    if (Platform.isAndroid) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      return [
        Permission.camera,
        if (sdk < 33) Permission.storage,
      ];
    }
    return [Permission.camera, Permission.photos];
  }

  static String getName(){
    final name = Get.find<AuthService>().user.value.name ?? '';
    final trimmed = name.trim();

    if (trimmed.isEmpty) return '';

    final parts = trimmed.split(' ');

    // If only one word → return first 2 letters
    if (parts.length == 1) {
      return parts.first.length >= 2
          ? parts.first.substring(0, 2).toUpperCase()
          : parts.first.toUpperCase();
    }

    // First letter of first + first letter of last
    final firstInitial = parts.first[0];
    final lastInitial = parts.last[0];

    return (firstInitial + lastInitial).toUpperCase();
    return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'").format(DateTime.now());
  }

  static String getTipsRandomImage(){
    var random = Random();
    int number = random.nextInt(8) + 1;
    String image = "";
    switch(number){
      case 1:
        image = ImageResource.instance.tip1Image;
        break;
      case 2:
        image = ImageResource.instance.tip2Image;
        break;
      case 3:
        image = ImageResource.instance.tip3Image;
        break;
      case 4:
        image = ImageResource.instance.tip4Image;
        break;
      case 5:
        image = ImageResource.instance.tip5Image;
        break;
      case 6:
        image = ImageResource.instance.tip6Image;
        break;
      case 7:
        image = ImageResource.instance.tip7Image;
        break;
      case 8:
        image = ImageResource.instance.tip8Image;
        break;
      default:
        image = ImageResource.instance.tip1Image;
    }
    return image;
  }

  static Future<bool> checkPermission() async {
    List<Permission> permissions = [];

    if (Platform.isAndroid) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      ("Android SDK => $sdk").logPrint();
      permissions = [
        Permission.camera,
        if (sdk < 33) Permission.storage,
      ];
    } else {
      permissions = [
        Permission.camera,
        Permission.photos,
      ];
    }

    bool allGranted = true;

    for (var p in permissions) {
      final status = await p.status;

      if (p == Permission.photos) {
        if (!(status.isGranted || status.isLimited)) {
          allGranted = false;
        }
      } else {
        if (!status.isGranted) {
          allGranted = false;
        }
      }
    }

    if (allGranted) return true;

    final result = await permissions.request();

    bool grantedAfterRequest = true;

    for (var p in permissions) {
      final status = result[p];

      if (p == Permission.photos) {
        if (!(status?.isGranted == true || status?.isLimited == true)) {
          grantedAfterRequest = false;
        }
      } else {
        if (!(status?.isGranted == true)) {
          grantedAfterRequest = false;
        }
      }
    }

    if (grantedAfterRequest) return true;

    bool permanentlyDenied = result.values.any(
          (status) => status.isPermanentlyDenied,
    );

    toastShow(
      message: "Permission required to continue",
      error: true,
    );

    return false;
  }
  static Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static bool isVersionLessThan(String current, String force) {
    List<int> currentParts = current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> forceParts = force.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    int maxLength = currentParts.length > forceParts.length ? currentParts.length : forceParts.length;
    for (int i = 0; i < maxLength; i++) {
      int c = i < currentParts.length ? currentParts[i] : 0;
      int f = i < forceParts.length ? forceParts[i] : 0;
      if (c < f) return true;
      if (c > f) return false;
    }
    return false;
  }
  static Color hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff'); // add opacity
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }


}
