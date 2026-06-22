import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
class VendorServiceShimmerUI extends StatelessWidget {
  const VendorServiceShimmerUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width/3.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color:ColorResource.instance.borderColor ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: ColorResource.instance.grey_1,
            highlightColor: ColorResource.instance.white,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:ColorResource.instance.grey_1
              ),
              padding:const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Shimmer.fromColors(
              baseColor: ColorResource.instance.grey_1,
              highlightColor: ColorResource.instance.white,
              child:Container(height: 15, width: 100,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResource.instance.grey_1),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DateSlotShimmer extends StatelessWidget {
  const DateSlotShimmer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorResource.instance.grey_1,
      highlightColor: ColorResource.instance.white,
      child: Container(
        width: 50,
        height: 80,
        margin:const EdgeInsets.only(right: 15),
        padding:const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color:ColorResource.instance.grey_1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color:ColorResource.instance.borderColor,width: 1.5)
        ),
      ),
    );
  }
}

class TimeSlotShimmer extends StatelessWidget {
  const TimeSlotShimmer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorResource.instance.grey_1,
      highlightColor: ColorResource.instance.white,
      child: Container(
        width: 150,
        height: 35,
        margin:const EdgeInsets.only(right: 15),
        padding:const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
            color:ColorResource.instance.grey_1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color:ColorResource.instance.borderColor,width: 1.5)
        ),
      ),
    );
  }
}
