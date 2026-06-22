
import 'package:flutter/material.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';

class YTabBar extends StatelessWidget implements PreferredSizeWidget {

  // if we want to  add the background color to tabs you have to wrap them in material widget.
  // to do that we need [preferred size widget] and thats why created custom class
  const YTabBar({super.key, required this.tabs, this.label, this.tabBarIndicatorSize});

  final List<Widget> tabs;
  final TextStyle? label;
  final TabBarIndicatorSize? tabBarIndicatorSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TabBar(
          isScrollable: true,
          labelStyle: label??StyleResource.instance.styleBold(DimensionResource.fontSizeExtraLarge, ColorResource.instance.white),
          indicatorColor: ColorResource.instance.white,
          indicatorSize: tabBarIndicatorSize,
          labelColor: ColorResource.instance.white,
          unselectedLabelColor: ColorResource.instance.grey_3,
          tabAlignment: TabAlignment.start,
          tabs:tabs,
        ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56);
}
