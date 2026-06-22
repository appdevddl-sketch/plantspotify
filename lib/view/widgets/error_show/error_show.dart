
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';

import '../../../model/utils/style_resource.dart';
class ErrorMessage extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  const ErrorMessage({
    Key? key,
    @required this.errorDetails,
  })  : assert(errorDetails != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Something is not right here...",
            style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: Text(
              errorDetails?.exception.toString()??"",
              style: StyleResource.instance.styleMedium(12, Colors.grey),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
