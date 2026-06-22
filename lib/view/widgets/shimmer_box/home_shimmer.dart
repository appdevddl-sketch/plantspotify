import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/decoration_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
            height: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageResource.instance.homeBannerImage),
                    fit: BoxFit.fill
                )
            ),
            padding:const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor: ColorResource.instance.grey_1,
                  highlightColor: ColorResource.instance.white,
                  child:Container(height: 20, width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResource.instance.grey_1),
                  ),
                ),
                const SizedBox(height: DimensionResource.marginSizeSmall,),
                Shimmer.fromColors(
                  baseColor: ColorResource.instance.grey_1,
                  highlightColor: ColorResource.instance.white,
                  child:Container(height: 12, width: 200,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResource.instance.grey_1),
                  ),
                )
              ],
            ),
      
          ),
          const SizedBox(height: DimensionResource.marginSizeExtraLarge,),
          Shimmer.fromColors(
            baseColor: ColorResource.instance.grey_1,
            highlightColor: ColorResource.instance.white,
            child: Container(
              height: 210,
              margin:const EdgeInsets.only(bottom: DimensionResource.marginSizeDefault,left:DimensionResource.marginSizeDefault,right: DimensionResource.marginSizeDefault ),
              padding: const EdgeInsets.all(DimensionResource.marginSizeDefault),
              decoration: BoxDecoration(
                  boxShadow: DecorationResource.instance.containerBoxShadow(),
                  color: ColorResource.instance.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: ColorResource.instance.lightMainColor)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
            child: Text("Most Order Items",style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.textColor),),
          ),
          const SizedBox(height: DimensionResource.marginSizeDefault,),

          SizedBox(
            height: 165,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(5, (index) => Padding(
                padding: EdgeInsets.only(left: index==0?DimensionResource.marginSizeDefault:0),
                child: Shimmer.fromColors(
                  baseColor: ColorResource.instance.grey_1,
                  highlightColor: ColorResource.instance.white,
                  child: Container(
                    height: 165,
                    width: 165,
                    margin: const EdgeInsets.only(right: DimensionResource.marginSizeDefault),
                    padding:const  EdgeInsets.all(DimensionResource.marginSizeSmall),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorResource.instance.lightMainColor),
                        borderRadius: BorderRadius.circular(15),
                        color: ColorResource.instance.extraLightMainColor
                    ),
                  ),
                ),
              )),
            ),
          )
      
        ],
      ),
    );
  }
}
