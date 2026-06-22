import 'package:flutter/cupertino.dart';

import '../../../model/utils/color_resource.dart';

Widget loaderHelperUi({double ?radius,Key ?key,Color ?loaderColor}) {
  return  Center(
    child: CupertinoActivityIndicator(
      key: key??const Key(""),
      animating: true,
      color: loaderColor??ColorResource.instance.mainColor,
      radius:radius?? 25,
    ),
  );
}
