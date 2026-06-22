import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plants_spotify/model/utils/in_app_purchase/in_app_purchase_util.dart';
import 'package:plants_spotify/view/widgets/error_show/error_show.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/view_model/notification/my_notification.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'firebase_options.dart';
import 'model/network_calls/dio_client/get_it_instance.dart';
import 'model/services/auth_service.dart';
import 'model/services/globleService.dart';
import 'model/services/translation_service.dart';
import 'model/utils/app_setting/app_globals.dart';
import 'model/utils/color_resource.dart';
import 'model/utils/package_info_util.dart';

Future<void> main() async {
  Globals.appEnvironment = AppFlavor.dev;
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "app_name".tr,
      builder: kDebugMode
          ? (BuildContext context, Widget? widget) => responsiveScreen(context, widget)
          : (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return ErrorMessage(errorDetails: errorDetails);
        };
        return responsiveScreen(context, widget);
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorResource.instance.mainColor,
          selectionColor: ColorResource.instance.mainColor,
          selectionHandleColor: ColorResource.instance.mainColor,
        ),
      ),
      /// Locales
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<TranslationService>().fallbackLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// In app purchase bindings
      initialBinding: BindingsBuilder(() {
        Get.put<InAppPurchaseUtils>(InAppPurchaseUtils.instance);
      }),
      /// Routes
      getPages: AppPages.routes,
      initialRoute: Routes.splashScreen,
      defaultTransition: Transition.circularReveal,
    ));
  });
}

initServices() async {
  Get.log('starting services ...');

  PackageInfoUtil.instance.initClass();


  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await dotenv.load(fileName: "assets/app/.env");
  await getInit();
  await GetStorage.init();

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => GlobalService().init());
  await Get.putAsync(() => TranslationService().init());

  MyNotification.initialize(FlutterLocalNotificationsPlugin());
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  Get.log('All services started...');
}


Widget responsiveScreen(context, widget) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: const TextScaler.linear(1.0),
    ),
    child: Container(
      color: ColorResource.instance.white, // <-- background here
      child: ResponsiveBreakpoints.builder(
        child: BouncingScrollWrapper(
          dragWithMouse: true,
          child: widget!,
        ),
        breakpoints: const [
          Breakpoint(start: 0, end: 470, name: MOBILE),
          Breakpoint(start: 470, end: 800, name: MOBILE),
          Breakpoint(start: 800, end: 1000, name: TABLET),
          Breakpoint(start: 1000, end: 1200, name: TABLET),
          Breakpoint(start: 1200, end: 2460, name: DESKTOP),
          Breakpoint(start: 2460, end: double.infinity, name: '4K'),
        ],
      ),
    ),
  );
}

