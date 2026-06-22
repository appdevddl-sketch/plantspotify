  import 'dart:io';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:flutter/material.dart';
  import 'package:gap/gap.dart';
  import 'package:plants_spotify/model/services/auth_service.dart';
  import 'package:plants_spotify/model/utils/app_constants.dart';
  import 'package:plants_spotify/model/utils/color_resource.dart';
  import 'package:plants_spotify/model/utils/decoration_resource.dart';
  import 'package:plants_spotify/model/utils/dimensions_resource.dart';
  import 'package:plants_spotify/model/utils/image_resource.dart';
  import 'package:plants_spotify/model/utils/in_app_purchase/in_app_purchase_util.dart';
  import 'package:plants_spotify/model/utils/style_resource.dart';
  import 'package:plants_spotify/view/widgets/button_view/common_button.dart';
  import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
  import 'package:plants_spotify/view/widgets/common/helper.dart';
  import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';
  import 'package:plants_spotify/view_model/routes/app_pages.dart';
  import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
  import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
  import 'package:plants_spotify/view/widgets/shimmer_box/view_shimmers/subscription_view_shimmer.dart';
  import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
  import 'package:plants_spotify/view_model/controller/root_view_contrller/subscription_controller/subscription_controller.dart';
  import 'package:get/get.dart';

  class SubscriptionScreen2 extends StatelessWidget {
    const SubscriptionScreen2({super.key, required this.controller});
    final SubscriptionController controller;

    @override
    Widget build(BuildContext context) {

      return Obx((){
        if(controller.subscriptionList.isEmpty){
          return SubscriptionShimmer();
        }else{
          return Obx(
                ()=> YRoundedContainer(
                  height: HelperFunction.screenHeight(),
                  width: HelperFunction.screenWidth(),
                  radius: 0,
                  gradient: LinearGradient(
                    colors: [ Color(0xffF0FFDF), Color(0xffF0FFDF), Color(0xffFFFFFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.3, 0.5],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                height: 35,
                                width: 35,
                                padding: const EdgeInsets.all(DimensionResource.marginSizeSmall),
                                decoration: BoxDecoration(
                                  color: ColorResource.instance.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: DecorationResource.instance.containerBoxShadow(ColorResource.instance.grey),
                                ),
                                child: Image.asset(
                                  ImageResource.instance.backArrowIcon,
                                  height: 11,
                                  color: ColorResource.instance.black,
                                ),
                              ),
                            ).paddingSymmetric(vertical: DimensionResource.paddingSizeExtraSmall),
                            Expanded(child: Center(child: Text("subscription_plan".tr,style: StyleResource.instance.styleBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeSmall))),
                          ],
                        ).paddingAll(DimensionResource.marginSizeDefault),
                        SizedBox(
                          width: HelperFunction.screenWidth(),
                          height: HelperFunction.screenWidth() * .60,
                          child: Stack(
                              children: [
                                Positioned(left : 0,child: Image.asset(ImageResource.instance.subPlantImage4,width: HelperFunction.screenWidth() * 0.25,)),
                                Positioned(bottom:0,left : 10,child: Image.asset(ImageResource.instance.subPlantImage2,height: 100,)),
                                Positioned(right : 0,child: Image.asset(ImageResource.instance.subPlantImage3,width: HelperFunction.screenWidth() * 0.75,)),
                                    
                              ]
                          ),
                        ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                        if(Get.find<AuthService>().user.value.isPremium == true && Get.find<AuthService>().user.value.currentActiveSubscription != null)
                        YRoundedContainer(
                          backgroundColor: ColorResource.instance.transparent,
                          margin: EdgeInsets.all(DimensionResource.marginSizeDefault),
                          radius: 5,
                          showBorder: true,
                          borderColor: ColorResource.instance.borderLiteGreen,
                          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch, // ensures full height
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "active_plan".tr,
                                            style: StyleResource.instance.styleBold(
                                              DimensionResource.fontSizeDefault,
                                              ColorResource.instance.btnGreenColor,
                                            ),
                                          ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
                                          Text(
                                            Get.find<AuthService>().user.value.currentActiveSubscription?.plan?.name??"",
                                            style: StyleResource.instance.styleSemiBold(
                                              DimensionResource.fontSizeDefault,
                                              ColorResource.instance.textDarkGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    VerticalDivider(
                                      color: ColorResource.instance.borderLiteGreen,
                                      thickness: 1,
                                      width: 20,
                                    ),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "valid_until".tr,
                                            style: StyleResource.instance.styleBold(
                                              DimensionResource.fontSizeDefault,
                                              ColorResource.instance.btnGreenColor,
                                            ),
                                          ).paddingOnly(bottom: DimensionResource.paddingSizeExtraSmall),
                                          Text(
                                            HelperFunction.formatFullDateTime(Get.find<AuthService>().user.value.currentActiveSubscription?.expiryDate.toString()??"")??"",
                                            style: StyleResource.instance.styleSemiBold(
                                              DimensionResource.fontSizeDefault,
                                              ColorResource.instance.textDarkGreenColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if(Get.find<AuthService>().user.value.currentActiveSubscription?.isAutoRenewing == true)
                              GestureDetector(
                                onTap: () => controller.cancelSubscription(),
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
                                  padding: EdgeInsets.symmetric(vertical: DimensionResource.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.red.shade300),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel_outlined, color: Colors.red.shade400, size: 18),
                                      Gap(DimensionResource.paddingSizeExtraSmall),
                                      Text(
                                        "cancel_subscription".tr,
                                        style: StyleResource.instance.styleMedium(
                                          DimensionResource.fontSizeDefault,
                                          Colors.red.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).paddingOnly(top: 20),
                            ],
                          ),
                        ),
                        if(Get.find<AuthService>().user.value.isPremium == true &&
                            Get.find<AuthService>().user.value.currentActiveSubscription?.plan?.type?.toLowerCase() == "subscription")

                        Text("plant_scan_pricing_plans".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.textDarkGreenColor),).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                        ListViewHorizontalSlider(
                          length: controller.subscriptionList.length,
                          items: (int index) {
                            return Obx(() {
                              final bool isSelected = controller.selectedIndex.value == index;
                              return GestureDetector(
                                      onTap: () => controller.onTabSelected(index),
                                      child: AnimatedContainer(
                                        height: 40,
                                        padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeDefault,vertical: DimensionResource.marginSizeSmall),
                                        duration: const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ColorResource.instance.btnGreenColor
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: ColorResource.instance.btnGreenColor,
                                          ),
                                        ),
                                        child:  GestureDetector(
                                          onTap: () => controller.onTabSelected(index),
                                          child: Center(
                                            child: Text(controller.subscriptionList[index].name.toString()??"",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall,isSelected ? ColorResource.instance.white : ColorResource.instance.btnGreenColor),),
                                          ),
                                        ),
                                      ),
                                    ).paddingSymmetric(horizontal: DimensionResource.paddingSizeExtraSmall);
                            },
                            );
                          },
                                    
                        ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                        SizedBox(
                          height: HelperFunction.screenWidth() * .68,
                          child: CarouselSlider(
                            carouselController: controller.carouselController,
                            options: CarouselOptions(
                              // height: HelperFunction.screenWidth() * 0.30,
                              viewportFraction: 0.7,
                              aspectRatio: 1.6,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                controller.onCarouselChanged(index);
                              },
                            ),
                            items: List.generate(controller.subscriptionList.length, (index) {
                              return YRoundedContainer(
                                onTap: () {
                                  if (controller.isTermsAccepted.value) {
                                    controller.subscriptionPurchase();
                                  } else {
                                    toastShow(message: "please_accept_terms".tr, error: true);
                                  }
                                },
                                width: HelperFunction.screenWidth() * .60,
                                showBorder: true,
                                boxshadow: [
                                  BoxShadow(
                                    color: ColorResource.instance.btnGreenColor
                                        .withValues(alpha: .5),
                                    spreadRadius: 1,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                                borderColor: ColorResource.instance.btnGreenColor
                                    .withValues(alpha: 0.5),
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.all(
                                    DimensionResource.marginSizeDefault),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Gap(DimensionResource.marginSizeExtraSmall),
                                      RichText(text:
                                      TextSpan(
                                          children:[
                                            //   TextSpan(
                                            //     text: "Plan name",
                                            //     style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_2,)
                                            // ),
                                            TextSpan(
                                                text: controller.subscriptionList[index].name,
                                                style: StyleResource.instance.styleBold(
                                                  DimensionResource.fontSizeLarge,
                                                  ColorResource.instance.btnGreenColor,)
                                            )
                                          ]
                                      )).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                                    
                                      Text(
                                        "${AppConstants.instance.currencySymbol}${controller.subscriptionList[index].price}",
                                        style: StyleResource.instance.styleBold(
                                          DimensionResource.fontSizeLarge,
                                          ColorResource.instance.black,
                                        ),
                                      ).paddingOnly(bottom: DimensionResource.paddingSizeSmall),
                                      Text(controller.subscriptionList[index].description??"",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textDarkGreenColor),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                        // ── Terms & Privacy checkbox ──────────────────────
                        Obx(() => GestureDetector(
                          onTap: () => controller.isTermsAccepted.value = !controller.isTermsAccepted.value,
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: controller.isTermsAccepted.value,
                                  activeColor: ColorResource.instance.btnGreenColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (val) => controller.isTermsAccepted.value = val ?? false,
                                ),
                              ),
                              Gap(DimensionResource.paddingSizeExtraSmall),
                              Expanded(
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "by_subscribing_you_agree_to_our".tr,
                                      style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_3),
                                    ),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(Routes.htmlContentView, arguments: {"type": 2, "title": "terms_of_use".tr}),
                                      child: Text(
                                        "terms_of_use".tr,
                                        style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.btnGreenColor),
                                      ),
                                    ),
                                    Text(
                                      " ${"and".tr} ",
                                      style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.textColor_3),
                                    ),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(Routes.htmlContentView, arguments: {"type": 3, "title": "privacy_policy".tr}),
                                      child: Text(
                                        "privacy_policy".tr,
                                        style: StyleResource.instance.styleMedium(DimensionResource.fontSizeSmall, ColorResource.instance.btnGreenColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )).paddingSymmetric(horizontal: DimensionResource.paddingSizeDefault).paddingOnly(bottom: DimensionResource.paddingSizeDefault),
                        // ── Continue button (dimmed until checkbox is ticked) ──
                        Obx(() {
                          final canProceed = controller.isTermsAccepted.value && !controller.isPurchaseInProgress.value;
                          return Opacity(
                            opacity: controller.isTermsAccepted.value ? 1.0 : 0.45,
                            child: CommonButton(
                              text: "continue".tr,
                              loading: controller.isPurchaseInProgress.value,
                              onPressed: canProceed ? () => controller.subscriptionPurchase() : () {},
                            ),
                          );
                        }).paddingOnly(left: DimensionResource.paddingSizeDefault, right: DimensionResource.paddingSizeDefault, bottom: DimensionResource.paddingSizeDefault),
                        YInkwell(
                          onTap: ()=>controller.restorePurchase(),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(ImageResource.instance.restorePurchaseIcon,height:  18,color: ColorResource.instance.textColor_3,),
                            Gap(DimensionResource.paddingSizeExtraSmall),
                            Text("restore_purchase".tr,style: StyleResource.instance.styleMedium(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_3),),
                          ],
                        )).paddingOnly(bottom: DimensionResource.marginSizeExtraLarge),

                      ],
                    ),
                  ),
                ),
          );

        }
      });
    }
  }



