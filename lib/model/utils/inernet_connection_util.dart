import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionUtil{

  static InternetConnectionUtil? _instance;
  static InternetConnectionUtil get instance {
    _instance ??= InternetConnectionUtil._init();
    return _instance!;
  }
  InternetConnectionUtil._init();

  InternetConnection customInstance  =
  InternetConnection.createInstance(
    checkInterval: const Duration(seconds: 1),
  );


  Future<bool> isConnected() async => await customInstance.hasInternetAccess;
  StreamSubscription registerCallBack({required  Function() onConnected, required  Function() onDisconnected }){
    final StreamSubscription<InternetStatus> listener =
    customInstance.onStatusChange.listen(
          (InternetStatus status) {
        switch (status) {
          case InternetStatus.connected:
            onConnected();
            break;
          case InternetStatus.disconnected:
            onDisconnected();
            break;
        }
      },
    );

    return listener;

  }
  void unRegisterCallBack(StreamSubscription<InternetStatus> listener){listener.cancel();}


}