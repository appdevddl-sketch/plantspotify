import 'package:get/get.dart';

class StringResource {
  static StringResource? _instance;

  static StringResource get instance => _instance ??= StringResource._init();

  StringResource._init();

  String get currentUser => 'currentUser';
  String get currentUserIp => 'currentUserIp';
  String get loginKey =>"isLoggedIn";
  String get token =>"token";
  String get chatToken =>"ChatToken";
  String get isFirst => 'isFirst';
  String get selectedLocaleKey =>'selected_locale';
  String get fcmToken =>"fcm_token";
  String get currencySymbol =>'currency_symbol';

//temporary
  String get cart => 'cart';
  String get couponHistory => 'couponHistory';
  String get tempRewardBalance => 'tempRewardBalance';
  /// chatbot
  String get saveChatBotCartItem => 'saveChatBotCartItem';





  /// email
  String get enterEmailText => "Please enter email.".tr;
  String get enterCorrectEmailText => "Please enter correct email.".tr;

  /// password
  String get enterPasswordText => "Please enter password.".tr;
  String get enterCorrectPasswordText => "Password must be 8-20 characters long, include at least 1 uppercase letter, 1 number, and 1 special character.".tr;

  /// mobile number
  String get enterMobileText => "Please enter mobile number.".tr;
  String get enterCorrectMobileText => "Please enter correct mobile number.".tr;

  /// experience number
  String get enterExperienceText => "Please enter experience.".tr;
  String get enterCorrectExperienceText => "Please enter correct experience.".tr;

  /// zip number
  String get enterZipText => "Please enter zip code".tr;
  String get enterCorrectZipText => "Please enter correct zip code.".tr;

  /// date of birth
  String get dateOfBirthText => "Please enter date of birth".tr;

  /// name
  String  enterNameText(String ?name) => "Please enter ${name??'name'}.".tr;
  String  enterCorrectNameText(String ?name) => "Please enter correct ${name??'name'}.".tr;
  String  enterCorrectLengthText(String ?name) => "${"${name??'name'}".tr} length should be greater than 2";
  String  enterCorrectUserNameText(String ?name) => "Please enter valid ${"${name??'name'}".tr}";


  /// address
  String get enterAddressText => "Please enter your complete address.".tr;
  String get enterCorrectAddressText => "Please enter your correct complete address.".tr;

  /// bank name
  String get enterBankText => "Please enter your bank name.".tr;
  String get enterCorrectBankText => "Please enter correct bank name.".tr;

  String get enterAccountNoText => "Please enter account number.".tr;
  String get enterCorrectAccountNoText => "Please enter correct account number.".tr;

  // Notification
  String get isNotification =>'show_notification';

  // In-App Purchase
  String get processedPurchaseIds => 'processed_purchase_ids';
  String get pendingPurchasePlanMap => 'pending_purchase_plan_map';


}
