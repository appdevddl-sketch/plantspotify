import 'package:flutter/services.dart';

class InputFormattersResource {
  static InputFormattersResource ?_instance;
  static InputFormattersResource get instance => _instance??=InputFormattersResource._init();
  InputFormattersResource._init();

  List<TextInputFormatter> get numberAndIntegerFormatters => [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9 ]"),), LengthLimitingTextInputFormatter(30),];
  List<TextInputFormatter> get numberAndIntegerSpeicialCharactersFormatters => [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s!@#\$%^&*(),.?":{}|<>_\-+=/\\[\]`~]'),), LengthLimitingTextInputFormatter(30),];
  List<TextInputFormatter> get nameInputFormatters =>[ FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),LengthLimitingTextInputFormatter(60),];
  List<TextInputFormatter> get numberAndEmailInputFormatters =>[FilteringTextInputFormatter.allow(RegExp("[0-9 .@A-Za-z]")),LengthLimitingTextInputFormatter(50),];
  List<TextInputFormatter> get numberInputFormatters =>[FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(10),];
  List<TextInputFormatter> get experienceInputFormatters =>[FilteringTextInputFormatter.allow(RegExp("[0-9.]")),LengthLimitingTextInputFormatter(3),];
  List<TextInputFormatter> get zipcodeInputFormatters =>[ FilteringTextInputFormatter.allow(RegExp("[0-9]")),LengthLimitingTextInputFormatter(6),];
  List<TextInputFormatter> get emailInputFormatters =>[ FilteringTextInputFormatter.allow(RegExp("[0-9 .@A-Za-z]")),LengthLimitingTextInputFormatter(50),];
  List<TextInputFormatter> get passwordInputFormatters =>[LengthLimitingTextInputFormatter(15),];
  List<TextInputFormatter> get amountInputFormatters => [FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*$")),LengthLimitingTextInputFormatter(10),];
}
