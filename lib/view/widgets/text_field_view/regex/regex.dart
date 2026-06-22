

import 'package:flutter/foundation.dart';
import 'dart:developer' ;
import 'package:get/get_utils/get_utils.dart';

import '../../../../model/utils/string_resource.dart';

bool addressValid(String value) => RegExp(r'^[#.0-9a-zA-Z\s,-]+$').hasMatch(value);
bool isValidNum(String value) => RegExp(r'^[0-9]').hasMatch(value);

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension FormValidation on String {
  bool isNumeric() {
    return double.tryParse(this) != null;
  }
  isValidEmailValidation({required Function(String) onError}) {
    if (isEmpty) {
      onError(StringResource.instance.enterEmailText);
      return "";
    } else if (!isEmail) {
      onError(StringResource.instance.enterCorrectEmailText);
      return "";
    } else {
      onError("");
      return null;
    }
  }

  validatorEmailMobile({required Function(String) onError}) {
    List<String> carriers =['91', '92', '93', '94', '95'];
    if (isEmpty) {
      onError('Please enter email address or mobile number.'.tr);
      return '';
    } else if (!GetUtils.isEmail(this) && !GetUtils.isPhoneNumber(this)) {
      onError('Please enter valid email address or mobile number.'.tr);
      return '';
    } else if (GetUtils.isPhoneNumber(this) && !carriers.contains(substring(0, 2))) {
      onError('Please enter a valid mobile number.'.tr);
      return '';
    }else if (GetUtils.isPhoneNumber(this) && length != 9) {
      onError('Please enter 9 digit mobile number.'.tr);
      return '';
    }
    onError("");
    return null;
  }

  isValidPasswordValidation({required Function(String) onError}) {
     RegExp password = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,20}$');
     if (isEmpty) {
      onError(StringResource.instance.enterPasswordText);
      return "";
    } else if (!password.hasMatch(this)) {
      onError(StringResource.instance.enterCorrectPasswordText);
      return "";
    } else {
      onError("");
      return null;
    }
  }

  isValidDateOfBirthValidation({required Function(String) onError}) {
    if (isEmpty) {
      onError(StringResource.instance.dateOfBirthText);
      return "";
    } else {
      onError("");
      return null;
    }
  }

  isValidMobileNumberValidation({required Function(String) onError}) {
    if (isEmpty) {
      onError(StringResource.instance.enterMobileText);
      return "";
    } else if (length != 10) {
      onError(StringResource.instance.enterCorrectMobileText);
      return "";
    }else {
      onError("");
      return null;
    }
  }

  isValidZipCodeNumberValidation({required Function(String) onError}) {
    if (isEmpty) {
      onError(StringResource.instance.enterZipText);
      return "";
    } else if (length != 6) {
      onError(StringResource.instance.enterCorrectZipText);
      return "";
    } else {
      onError("");
      return null;
    }
  }

  isValidNameValidation({required Function(String) onError , String ?name}) {
    if (isEmpty) {
      onError(StringResource.instance.enterNameText(name));
      return "";
    }else if (length > 60) {
      onError(StringResource.instance.enterCorrectNameText(name));
      return "";
    } else if (length < 2) {
      onError(StringResource.instance.enterCorrectLengthText(name));
      return "";
    } else if (removeAllWhitespace == "") {
      onError(StringResource.instance.enterCorrectNameText(name));
      return "";
    }  else {
      onError("");
      return null;
    }
  }

    isValidNoteValidation({required Function(String) onError , String ?name}) {
    if (isEmpty) {
      onError(StringResource.instance.enterNameText(name));
      return "";
    } else if (length < 2) {
      onError(StringResource.instance.enterCorrectLengthText(name));
      return "";
    } else if (removeAllWhitespace == "") {
      onError(StringResource.instance.enterCorrectNameText(name));
      return "";
    }  else {
      onError("");
      return null;
    }
  }

  isValidUserNameValidation({required Function(String) onError , String ?name}) {

    if (isEmpty) {
      onError(StringResource.instance.enterNameText(name));
      return "";
    } else if (length > 30) {
      onError(StringResource.instance.enterCorrectNameText(name));
      return "";
    } else if (length < 2) {
      onError(StringResource.instance.enterCorrectLengthText(name));
      return "";
    } else if (trim().toLowerCase() == "user") {
      onError(StringResource.instance.enterCorrectUserNameText(name));
      return "";
    }else if (removeAllWhitespace == "") {
      onError(StringResource.instance.enterCorrectNameText(name));
      return "";
    }  else {
      onError("");
      return null;
    }
  }



}

extension PrintValue on Object{
  void logPrint ({String? message}) => {
    if(kDebugMode){
      log("${message??''}${toString()}")
    }
  };
}