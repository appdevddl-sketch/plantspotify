
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../view/widgets/common/helper.dart';

class TranslationService extends GetxService {
  final translations = <String, Map<String, String>>{}.obs;
  final fallbackLocale = Get.find<AuthService>().getUserLocale();


  /// must add language codes here
  static final languages = [
    'en_US',
  ];

  Future<TranslationService> init() async {
    for (var element in languages) {
      var file = await HelperFunction.getJsonFile('assets/locales/$element.json');
      translations.putIfAbsent(element, () => Map<String, String>.from(file));
      (translations).logPrint();
    }
    return this;
  }

  /// get list of supported local in the application
  List<Locale> supportedLocales() {
    return TranslationService.languages.map((locale) {
      return fromStringToLocale(locale);
    }).toList();
  }

  /// Convert string code to local object
  Locale fromStringToLocale(String locale) {
    if (locale.contains('_')) {
      // en_US
      return Locale(locale.split('_').elementAt(0), locale.split('_').elementAt(1));
    } else {
      // en
      return Locale(locale);
    }
  }

  static void changeLocale(String lang) async{
    Get.updateLocale(Locale(lang));
    await Get.find<AuthService>().saveUserLocale(lang);

  }
}
