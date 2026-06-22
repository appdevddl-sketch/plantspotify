import 'package:package_info_plus/package_info_plus.dart';


class PackageInfoUtil {

  static PackageInfoUtil? _instance;
  static PackageInfoUtil get instance {
    _instance ??= PackageInfoUtil._init();
    return _instance!;
  }
  PackageInfoUtil._init();


  PackageInfo? _packageInfo;
  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  Future<void> initClass() async {
    _packageInfo ??= await PackageInfo.fromPlatform();
     appName  = _packageInfo?.appName;
     packageName = _packageInfo?.packageName;
     version = _packageInfo?.version;
     buildNumber =_packageInfo?.buildNumber;


     return;
  }

}
