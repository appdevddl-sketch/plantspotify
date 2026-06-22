import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';

import '../../../model/utils/color_resource.dart';
import '../cached_network_image_widget/cachednetworkimagewidget.dart';


class ProfileImageViewHelper extends StatelessWidget {
  final String imageUrl;
  final double ?boxRound;
  final double ?borderWidth;
  final Color ?borderColor;
  final double ?borderRadius;
  final BoxFit ?boxFit;
  final VoidCallback ?onTap;
  final EdgeInsetsGeometry ?imagePadding;
  final bool showBoxShadow;


  const ProfileImageViewHelper({Key? key, required this.imageUrl,this.boxRound,this.borderWidth,this.boxFit,this.onTap, this.borderRadius, this.borderColor, this.imagePadding, this.showBoxShadow =true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    imageUrl.logPrint();
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap:onTap?? ()=>Navigator.of(context).push(PageRouteBuilder(opaque: false, barrierDismissible:true, pageBuilder: (BuildContext context, _, __)=>_buildImageZoomBoxUI(imageUrl))),
      child: Hero(
        tag: imageUrl,
        child: Container(
          width: boxRound??55,
          height: boxRound??55,
          padding:imagePadding?? EdgeInsets.zero,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius??500),
              border: Border.all(width: borderWidth??1.5, color:borderColor?? ColorResource.instance.white),
              color: ColorResource.instance.grey_1),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius??500),
              child: CachedNetworkImageWidget(imageUrl:imageUrl,fit: boxFit??BoxFit.fill, placeholder: const SizedBox.shrink(), errorWidget: CircleAvatar(
                  radius: 50,
                  backgroundColor:ColorResource.instance.orangeGradientColor1,
                  child: Text(HelperFunction.getName(),
                    style: StyleResource.instance.styleSemiBold(
                      25,
                      Colors.white,
                    ),
                  )
              )
              )
          ),
        ),
      ),
    );
  }
}

Widget _buildImageZoomBoxUI(String imageUrl){
  return Scaffold(
    backgroundColor: ColorResource.instance.black.withValues(alpha: .1),
    body: InkWell(
      onTap: ()=>Get.back(),
      child: Container(
        color: ColorResource.instance.black.withValues(alpha: .1),
        child: Center(
          child: Hero(
            tag:imageUrl,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 5, color: ColorResource.instance.white),
                  color: ColorResource.instance.orangeGradientColor1
              ),
              child: ClipOval(
                  child: CachedNetworkImageWidget(color: ColorResource.instance.transparent,imageUrl:imageUrl,fit: BoxFit.contain, placeholder: const SizedBox.shrink(), errorWidget: CircleAvatar(
                  radius: 50,
                      backgroundColor:ColorResource.instance.orangeGradientColor1,
                      child: Text(HelperFunction.getName(), style: StyleResource.instance.styleSemiBold(
                  40,
                  Colors.white,
                ),
              )
            ))),
            ),
          ),
        ),
      ),
    ),
  );
}
