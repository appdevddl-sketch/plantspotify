
import 'package:flutter/material.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';


class ListViewHorizontalSlider extends StatelessWidget {
  final int length;
  final Widget Function(int index) items;
  const ListViewHorizontalSlider({
    super.key, required this.length,required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResource.instance.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: DimensionResource.sm,bottom: DimensionResource.sm,left: DimensionResource.xs),
          child: Row(
            children: List.generate(length, (index){
              return items(index);
            }),
          ),
        ),
      ),
    );
  }
}
