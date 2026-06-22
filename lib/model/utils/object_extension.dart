// import 'package:common_setup/util.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as devtools show log;

extension LogPrint on Object {
  void  printLog ({String? message}) => {
    if(kDebugMode){
      devtools.log("${message??''}${toString()}")
    }
  };

}


// extension FExtention on num {
//   num  toNumberAsFixedFraction ([int? fractionDigit]) {
//     return  Util.toNumberAsFixedFraction(this,fractionDigit: fractionDigit??2);
//   }
//
// }
// extension FDoubleExtention on double {
//   num  toNumberAsFixedFraction ([int? fractionDigit]) {
//     return  Util.toNumberAsFixedFraction(this,fractionDigit: fractionDigit??2);
//   }
// }
