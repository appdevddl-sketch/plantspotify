

  import 'package:flutter/material.dart';
  import 'package:gap/gap.dart';
  import 'package:get/get.dart';
  import 'package:get/get_utils/src/extensions/internacionalization.dart';
  import 'package:plants_spotify/model/model/root_view_models/accountview_models/faq_model.dart';
  import 'package:plants_spotify/model/utils/color_resource.dart';
  import 'package:plants_spotify/model/utils/dimensions_resource.dart';
  import 'package:plants_spotify/model/utils/image_resource.dart';
  import 'package:plants_spotify/model/utils/style_resource.dart';
  import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
  import 'package:plants_spotify/view/widgets/common/helper.dart';
  import 'package:plants_spotify/view/widgets/loader_helper/loader_helper_ui.dart';
  import 'package:plants_spotify/view/widgets/no_data_screen/noDataScreen.dart';
  import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/faq_shimmer.dart';
  import 'package:plants_spotify/view_model/controller/root_view_contrller/account_view_controller/help_controller/help_controller.dart';




  class HelpScreen extends StatelessWidget {
    const HelpScreen
        ({super.key});

    @override
    Widget build(BuildContext context) {
      return BaseView(viewControl: HelpController(),
          appbarPerimeter: AppbarPerimeter(title: "help".tr,centerTitle: true,appBarBackGroundColor: ColorResource.instance.grey_1),
          onPageBuilder: (BuildContext context,HelpController controller)=>_buildMainView(context,controller));
    }
  }

  Widget _buildMainView(BuildContext context,HelpController controller){
    return Obx((){
      if(controller.faqData.value.status !=false && controller.faqPaginationViewController.itemList.isNotEmpty) {

        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(bottom: 0,left: 0,child: Image.asset(ImageResource.instance.leaf11Image,width: HelperFunction.screenWidth() * .50,)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("faq".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),).paddingSymmetric(vertical:DimensionResource.paddingSizeDefault),
                Expanded(
                  child: PaginationView<FaqData>(
                      onRefresh: ()=>controller.onInit(),
                      // sidePadding:const EdgeInsets.symmetric(vertical: DimensionResource.marginSizeDefault),
                      showItemList: controller.faqPaginationViewController.itemList,
                      pagingScrollController:controller.faqPaginationViewController,
                      mainView:(BuildContext context, int index,FaqData itemData) =>_buildClothRow(
                          context: context,
                          sNo: "${index+1}",
                          title: itemData.question??"",
                          dec: itemData.answer ??""
                      ).paddingOnly(bottom: DimensionResource.marginSizeDefault)
                  ),
                )
              ],
            ).paddingOnly(left: DimensionResource.paddingSizeDefault,right: DimensionResource.paddingSizeDefault,bottom: DimensionResource.paddingSizeDefault),

          ],
        );
      }
      else if(controller.faqData.value.status==true && controller.faqPaginationViewController.itemList.isEmpty){
        return   NoDataFoundScreen(message: "No questions found".tr);
      }
      else {
        return FaqShimmerScreen();
      }
    });
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(bottom: 0,left: 0,child: Image.asset(ImageResource.instance.leaf11Image,width: HelperFunction.screenWidth() * .50,)),
        ListView(
            padding: const EdgeInsets.symmetric(horizontal:DimensionResource.marginSizeDefault),
            children:[
              Text("faq".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeDefault, ColorResource.instance.textDarkGreenColor),).paddingAll(DimensionResource.marginSizeDefault),
              ...List.generate(10, (index){
                return  _buildClothRow(
                    context: context,
                    sNo: "${index+1}",
                    title: "Why are Tulsi leaves turning yellow?"??"",
                    dec: "Yellow leaves usually mean overwatering or lack of sunlight. Allow the soil to dry between waterings and place the plant in at least 4–6 hours of direct sunlight."??""
                );
              })

            ]


        ).paddingOnly(left: DimensionResource.marginSizeExtraSmall /2,right: DimensionResource.marginSizeExtraSmall /2,top: DimensionResource.marginSizeExtraSmall /2,bottom: DimensionResource.marginSizeDefault),
      ],
    );

  }
  Widget _buildClothRow({
    required BuildContext context,
    required String sNo,
    required String title,
    required String dec,
  }) {
    final isExpanded = false.obs;

    return Obx(() => Container(
      margin: const EdgeInsets.only(
        bottom: DimensionResource.marginSizeSmall,
      ),
      decoration: BoxDecoration(
        color: ColorResource.instance.white,
        border: Border.all(
          color: ColorResource.instance.dividerGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),


      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            dividerColor: Colors.transparent,
            iconTheme:
            IconThemeData(color: ColorResource.instance.mainColor),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              DimensionResource.marginSizeDefault,
              0,
              DimensionResource.marginSizeDefault,
              DimensionResource.marginSizeLarge,
            ),

            trailing: Icon(
              isExpanded.value
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: ColorResource.instance.black,
            ),

            onExpansionChanged: (expanded) {
              isExpanded.value = expanded;
            },

            title: Text(
              "$sNo. $title",
              style: StyleResource.instance.styleSemiBold(  
                DimensionResource.fontSizeSmall-1,
                ColorResource.instance.textDarkGreenColor,
              ),
            ),

            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  dec,
                  style: StyleResource.instance.styleRegular(
                    DimensionResource.fontSizeSmall-1,
                    ColorResource.instance.textColor_2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }






