import 'dart:isolate';

import 'package:plants_spotify/model/utils/device_info_util.dart';
import 'package:plants_spotify/model/utils/object_extension.dart';
import 'package:plants_spotify/model/utils/package_info_util.dart';
// import 'package:common_setup/setup.dart';
// import 'package:common_setup/util/app_setting/app_config.dart';
// import 'package:common_setup/util/device_info_util.dart';
// import 'package:common_setup/util/info_utils/package_info_util.dart';
import 'package:dio/dio.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';


import 'dart:io';
// import 'package:util_resource/src/util_resource_setting.dart';
// import 'package:util_resource/util/notification/notification_manager.dart';



Dio? dio  ;



Dio? _createDio() {
  dio ??= Dio();

  // if(kDebugMode) {
  //   // dio?.interceptors.add(PrettyDioLogger());
  //   dio?.interceptors.add(
  //     DioLoggingInterceptor(
  //       level: Level.body,
  //       compact: false,
  //     ),
  //   );
  // }
  return dio;
}


class DownloadUtil{

  final Function() onStart;
  final Function() onComplete;
  final Function() onError;
  DownloadUtil({required this.onStart,required this.onComplete,required this.onError}){
    dio??_createDio();
  }


  Future<void> createFolderAndDownloadFile({
    bool isShowNotification = false,
    bool isPathCache = false,
    String? folderName,
    required String url, required String fileNameWithExtensions}) async {
    var info;
    if(Platform.isAndroid) {
      info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
    }
    else{
      info = await DeviceInfoUtil.instance.deviceInfoPlugin.iosInfo;

    }


    /*--------For create folder in memory
     Permission is required-------------*/


    if(Platform.isIOS){
      downloadIOSFile(folderName: folderName ?? PackageInfoUtil.instance.appName, fileNameWithExtensions: fileNameWithExtensions, url: url,isShowNotification: isShowNotification);

    }

    else if (Platform.isAndroid && (info.version.sdkInt ?? 0) <= 32) {

      PermissionStatus status = await Permission.storage.status;
      status.printLog();
      if(status == PermissionStatus.granted){
        downloadFile(folderName: folderName ?? PackageInfoUtil.instance.appName, fileNameWithExtensions: fileNameWithExtensions, url: url,isShowNotification: isShowNotification, isPathCache: isPathCache,);
      }
      else if(status == PermissionStatus.permanentlyDenied){
        toastShow(message: "Storage permission is required to download files.", error: true);
      }
      else{
        if(await Permission.storage.request().isGranted){
          downloadFile(folderName: folderName ?? PackageInfoUtil.instance.appName, fileNameWithExtensions: fileNameWithExtensions, url: url,isShowNotification: isShowNotification,isPathCache: isPathCache);
        }
      }
    }
    else if(Platform.isAndroid && (info.version.sdkInt ?? 0) <= 34){
      await Permission.storage.request().isGranted;
      downloadFile(folderName: folderName ?? PackageInfoUtil.instance.appName, fileNameWithExtensions: fileNameWithExtensions, url: url,isShowNotification: isShowNotification,isPathCache: isPathCache);

    }

  }

  void downloadIOSFile({String? folderName,required String url, required String fileNameWithExtensions,required bool isShowNotification}) async {
    //Path for creating your folder.

    var tempDir = await getApplicationDocumentsDirectory();
    var tempPath = tempDir.absolute.path;
    tempPath.toString().printLog(message: "path: ");

    var path = Directory('$tempPath/$folderName');

    /// if folder exists in four phone memory.
    if ((await path.exists())) {

      //download call
      apiDownload(isShowNotification,url,path.path,fileNameWithExtensions);

    } else {
      /// Create folder in your memory.
      path.create(recursive: true).then((value) async {
        //download call
        apiDownload(isShowNotification,url,value.path,fileNameWithExtensions);

      });
    }
  }

  void downloadFile({String? folderName,required String url, required String fileNameWithExtensions,required bool isShowNotification,  required  bool isPathCache,
  }) async {
    //Path for creating your folder.

    Directory path ;
    if(isPathCache){
      var tempDir = await getApplicationCacheDirectory();
      var tempPath = tempDir.absolute.path;
      tempPath.toString().printLog(message: "pathCache: ");
      path = Directory('$tempPath/$folderName');

    }
    else{
      var tempDir= await getExternalStorageDirectory();
      tempDir.toString().printLog(message: "pathExternal: ");
      var tempPath = tempDir?.absolute.path.replaceAll('/Android/data/${PackageInfoUtil.instance.packageName}/files', '');
      tempPath.toString().printLog(message: "pathExternal: ");
      path = Directory('$tempPath/Download/$folderName');
    }


    /// if folder exists in four phone memory.
    if ((await path.exists())) {

      //download call
      apiDownload(isShowNotification,url,path.path,fileNameWithExtensions);

    } else {
      /// Create folder in your memory.
      path.create(recursive: true).then((value) async {
        //download call
        apiDownload(isShowNotification,url,value.path,fileNameWithExtensions);

      });
    }
  }



  void apiDownload(bool isShowNotification,String url,String folderPath,String fileNameWithExtension) async {
    //onStart();
    DownloadTaskIsolate.instance.useDownloadIsolate('',isShowNotification, url, folderPath, fileNameWithExtension, onStart: onStart, onComplete: onComplete, onError: onError);

  }
    /*
  TODO do not delete this method it is commented because
    it will now made with isolate but it is required to copy
    this in other project to remember the flow and concept
    if isolate do not work properly
  void apiDownload(bool isShowNotification,String url,String folderPath,String fileNameWithExtension) async {
    onStart();
    var currentID = DateTime.now().microsecond;
    try{

      var response = await dio?.get(
        url,
        onReceiveProgress: (received, total) async {
          if(isShowNotification){
            NotificationManager.showDownloadNotification(currentID,total,received,
                downloadStatus:total == received?DownloadStatus.completed:DownloadStatus.running,
                fileName: fileNameWithExtension,
                path: '$folderPath/$fileNameWithExtension');
          }

        },
        //Received data with List<int>
        options: Options(

            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      if(response?.statusCode == 200){

        File file = File('$folderPath/$fileNameWithExtension');
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response?.data);
        await raf.close();
        if(isShowNotification) {
          NotificationManager.showDownloadNotification(currentID, 0, 0,
              downloadStatus: DownloadStatus.completed,
              fileName: fileNameWithExtension,
              path: '$folderPath/$fileNameWithExtension');
        }
        onComplete();
      }
      else{
        if(isShowNotification) {
          NotificationManager.showDownloadNotification(currentID, 0, 0,
              downloadStatus: DownloadStatus.error,
              fileName: fileNameWithExtension,
              path: '$folderPath/$fileNameWithExtension');
        }
        onError();
      }

    }
    catch(e){
      if(isShowNotification) {
        NotificationManager.showDownloadNotification(currentID, 0, 0,
            downloadStatus: DownloadStatus.error,
            fileName: fileNameWithExtension,
            path: '$folderPath/$fileNameWithExtension');
      }
      onError();
      e.printLog(message: 'error download');
    }
  }
*/









  Future<String> getPath({String? folderName,bool isPathCache = false}) async {
    if(Platform.isAndroid){

      Directory path ;
      if(isPathCache){
        var tempDir = await getApplicationCacheDirectory();
        var tempPath = tempDir.absolute.path;
        tempPath.toString().printLog(message: "path: ");
        path = Directory('$tempPath/${folderName??PackageInfoUtil.instance.appName}');
        return path.path;
      }
      else{
          var tempDir = await getExternalStorageDirectory();
          var tempPath = tempDir?.absolute.path.replaceAll('/Android/data/${PackageInfoUtil.instance.packageName}/files', '');
          tempPath.toString().printLog(message: "path: ");
          var path = Directory('$tempPath/Download/${folderName??PackageInfoUtil.instance.appName}');
          return path.path;
      }
    }
    else{

      return '';
    }

  }

}


class DownloadTaskIsolate {


  static DownloadTaskIsolate? _instace;

  static DownloadTaskIsolate get instance =>
      _instace ??= DownloadTaskIsolate._();

  // Whatever private constructor you're using for this singleton
  DownloadTaskIsolate._();


  useDownloadIsolate(String token,bool isShowNotification,String url,String folderPath,String fileNameWithExtension,{required Function() onStart, required Function() onComplete, required Function() onError}) async {
    ReceivePort receivePort = ReceivePort();
    var rootToken = RootIsolateToken.instance!;
    Isolate downloadIsolate;

    try {
      downloadIsolate =   await Isolate.spawn(
          runDownloadIsolate, [
          rootToken,
          receivePort.sendPort, {
          'token':token,
          'is_notification':isShowNotification,
          'url':url,
          'folderPath':folderPath,
          'fileNameWithExtension': fileNameWithExtension

        }]);


      final receiveResponseStream = receivePort.asBroadcastStream();

      receiveResponseStream.listen((event) {

        if(event == 'onStart'){
          onStart();
        }
        else if(event == 'onComplete'){
          onComplete();
        }
        else if(event == 'onError'){
          onError();
        }

      });




    } on Object {
      debugPrint('Isolate Failed');
      receivePort.close();
    }




  }


  runDownloadIsolate(List<Object> message) async {
    Map argMap = message[2] as Map;

    String token =  argMap['token'];
    bool isShowNotification =  argMap['is_notification'];
    String url =  argMap['url'];
    String folderPath =  argMap['folderPath'];
    String fileNameWithExtension =  argMap['fileNameWithExtension'];

    SendPort resultPort = message[1] as SendPort;
    RootIsolateToken rootIsolateToken = message[0] as RootIsolateToken;

    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    var flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
    dio ??= Dio();
    /*if(kDebugMode) {
      dio?.interceptors.add(PrettyDioLogger());
      dio?.interceptors.add(
        DioLoggingInterceptor(
          level: Level.body,
          compact: false,
        ),
      );
    }*/



    resultPort.send('onStart');

    var currentID = DateTime.now().microsecond;

    try{
      var response = await dio?.get(
        url,
        onReceiveProgress: (received, total) async {
          ''.printLog(message: '$received  - $total');
          if(isShowNotification){
            // NotificationManager.showDownloadNotification(flutterNotificationPlugin,currentID,total,received,
            //     downloadStatus:total == received?DownloadStatus.completed:DownloadStatus.running,
            //     fileName: fileNameWithExtension,
            //     path: '$folderPath/$fileNameWithExtension');
          }

        },
        //Received data with List<int>
        options: Options(
            headers:token.isNotEmpty?{
              'Authorization': 'Bearer $token',
            }:null,
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      if(response?.statusCode == 200){

        File file = File('$folderPath/$fileNameWithExtension');
        file.existsSync().printLog(message: 'file exist');
        if(file.existsSync()){
          fileNameWithExtension = '${DateTime.now().millisecondsSinceEpoch}_$fileNameWithExtension';
          File file = File('$folderPath/$fileNameWithExtension');
          var raf = file.openSync(mode: FileMode.write);
          raf.writeFromSync(response?.data);
          await raf.close();

        }
        else{
          var raf = file.openSync(mode: FileMode.write);
          raf.writeFromSync(response?.data);
          await raf.close();
        }

        if(isShowNotification) {
          // NotificationManager.showDownloadNotification(flutterNotificationPlugin,currentID, 0, 0,
          //     downloadStatus: DownloadStatus.completed,
          //     fileName: fileNameWithExtension,
          //     path: '$folderPath/$fileNameWithExtension');
        }
        file.path.printLog(message: 'filepath');
        resultPort.send('onComplete');
      }
      else{
        if(isShowNotification) {
          // NotificationManager.showDownloadNotification(flutterNotificationPlugin,currentID, 0, 0,
          //     downloadStatus: DownloadStatus.error,
          //     fileName: fileNameWithExtension,
          //     path: '$folderPath/$fileNameWithExtension');
        }
        resultPort.send('onError');
      }

    }
    catch(e){
      if(isShowNotification) {
        // NotificationManager.showDownloadNotification(flutterNotificationPlugin,currentID, 0, 0,
            // downloadStatus: DownloadStatus.error,
            // fileName: fileNameWithExtension,
            // path: '$folderPath/$fileNameWithExtension');
      }
      resultPort.send('onError');
      e.printLog(message: 'error download');
    }

  }

}

