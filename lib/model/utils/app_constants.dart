import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/app_setting/app_globals.dart';






class AppConstants {
  static AppConstants? _instance;
  static AppConstants get instance => _instance ??= AppConstants();


  /// base url
  late final String baseUrl = "${dotenv.env['${Globals.appEnvironment}_BASE_API_URL']}";


  /// auth
  String get auth => '$baseUrl/auth';
  String get logout => '$baseUrl/auth/logout';
  String get deleteAccount => '$baseUrl/auth/delete-account';
  String get getProfile => '$baseUrl/profile';
  String get updateProfile => '$baseUrl/profile/update';
  String get updateLocation => '$baseUrl/profile/update-location';
  String get updateDeviceId => '$baseUrl/profile/update-device-id';
  String get getAppVersion => '$baseUrl/app-settings';
  String get getCountry => '$baseUrl/countries';




  /// Home
  String get searchPlants => '$baseUrl/plants/search';
  String get articles => '$baseUrl/articles';
  String get plants => '$baseUrl/plants';
  String get homeTypes => '$baseUrl/home-types';
  String get getTips => '$baseUrl/tips';
  String get getNotifications => '$baseUrl/notifications';
  String get diagnose => '$baseUrl/diagnose';
  String get getDiagnosisQuestions => '$baseUrl/diagnose/questions';
  String get identify => '$baseUrl/identify';
  String get getFeedbackQuestions => '$baseUrl/scan-feedback-questions';
  String get submitFeedbackData => '$baseUrl/scan-feedback-submit';
  String get getPlantIndexCategories => '$baseUrl/plant-categories';








  /// Nursery
  String get collection => '$baseUrl/my-nursery/collections';
  String get addPlantToCollection => '$baseUrl/my-nursery/add-plant';
  String get myNurseryPlants => '$baseUrl/my-nursery/plants';



  /// account Option
  String get faq => '$baseUrl/faqs';
  String get contactUs => '$baseUrl/contact-us';
  String get subscriptionPlans => '$baseUrl/subscription/plans';
  String get subscriptionPurchase=> '$baseUrl/subscription/purchase';
  String get subscriptionCancel=> '$baseUrl/subscription/cancel';
  String get subscriptionVerify=> '$baseUrl/subscription/verify';


  String get cms => '$baseUrl/cms';
  String get scanHistory => '$baseUrl/scan-history';












  /// Get User IP
  String get getUserIp  => 'http://ip-api.com/json';


  /// agora
  String get agoraAppId => dotenv.env["AGORA_APP_ID"]??""; // Live url

  /// google map key
  String get googleMapKey => dotenv.env['DEVELOPMENT_GOOGLE_MAP_API_KEY'] ?? dotenv.env['DEV_STAGING_GOOGLE_MAP_API_KEY'] ?? "";
  String get mapSearch => "https://maps.googleapis.com/maps/api/place/autocomplete/json";
  /// currency
  String get currencySymbol => '\$';
  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);
  String Function(double amount) get amountFormatWithDecimalDigits=>(double amount)=>formatCurrency.format(amount).toString().replaceAll(".00", "");
  final formatCurrencyWithoutSymbol = NumberFormat.currency(locale: "en_US", symbol: "\$", decimalDigits: 2);
  String Function(double amount) get amountFormatWithoutSymbol=>(double amount)=>formatCurrencyWithoutSymbol.format(amount).toString().replaceAll(".00", "");

}


