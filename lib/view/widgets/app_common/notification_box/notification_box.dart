import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/button_view/button_holders.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';

class NotificationBoxWidget extends StatelessWidget {
  const NotificationBoxWidget({
    super.key, this.count, this.imageUrl, this.iconColor, this.onPressed,
  });
  final String? count;
  final String? imageUrl;
  final Color? iconColor;
  final VoidCallback? onPressed;



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: ColorResource.instance.transparent,
              boxShadow: DecorationResource.instance.containerBoxShadow()
          ),
          child:ButtonResource.instance.buildIconButton(image: imageUrl ?? ImageResource.instance.notificationBellIcon, onTap: (){},height: 35,color: iconColor),
        ),
        if(true)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              height: 13,
              width: 13,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorResource.instance.greenColor),
              child: Center(
                child: Text(
                    count ?? "0",
                    style: StyleResource.instance.styleSemiBold(9, ColorResource.instance.white)
                ),
              ),
            ),
          ),
        YInkwell(
          onTap: onPressed ,
          child:const  SizedBox(
            height: 40,
            width: 40,
          ),
        )
      ],
    );
  }
}