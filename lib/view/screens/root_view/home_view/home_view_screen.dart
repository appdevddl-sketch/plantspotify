import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/search_results_model.dart';
import 'package:plants_spotify/model/services/auth_service.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/model/utils/decoration_resource.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/model/utils/font_resource.dart';
import 'package:plants_spotify/model/utils/image_resource.dart';
import 'package:plants_spotify/model/utils/style_resource.dart';
import 'package:plants_spotify/view/widgets/app_common/app_heading/app_heading.dart';
import 'package:plants_spotify/view/widgets/button_view/yinkwell.dart';
import 'package:plants_spotify/view/widgets/cached_network_image_widget/cachednetworkimagewidget.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_container.dart';
import 'package:plants_spotify/view/widgets/containers/rounded_image.dart';
import 'package:plants_spotify/view/widgets/sliders/horizontal_slider.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/home_controller/home_controller.dart';
import 'package:plants_spotify/view_model/controller/root_view_contrller/root_view_controller.dart';
import 'package:plants_spotify/view_model/routes/app_pages.dart';
import '../../../widgets/shimmer_box/view_shimmers/home_view_shimmer.dart';
import '../../base_view/base_view_screen.dart';
import 'plant_index_screen/plant_index_screen.dart';


class   HomeViewScreen extends StatelessWidget {
  const HomeViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(viewControl: HomeController(),
        showNetworkStatusBar: false,
        bottomSafeArea: false,
        backgroundColor: ColorResource.instance.white,
        onPageBuilder: (BuildContext context,HomeController controller)=>_buildMainView(context,controller));
  }
}

Widget _buildMainView(BuildContext context,HomeController controller){
  return _mainContentView(context,controller);

}
Widget _mainContentView(BuildContext context,HomeController controller){
  return RefreshIndicator(
    onRefresh: () async =>  controller.onRefresh(),
    color: ColorResource.instance.mainColor,
    child: SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          controller.isTrendingLoading.value == true ||  controller.isTipsLoading.value == true || controller.isArticlesLoading.value == true || controller.isPlantIndexLoading.value == true?   HomeShimmer() : ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageResource.instance.leaf7Image),
                      fit:BoxFit.cover
                  )
              ),
              width: HelperFunction.screenWidth(),

              child: Column(
                children: [
                  Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),
                  Row(
                    children: [

                      YInkwell(onTap: ()=>Get.find<RootViewController>().scaffoldKey.currentState!.openDrawer(),child:  CachedNetworkImageWidget(imageUrl:"",fit: BoxFit.fill,height:50,width:50,errorWidget: CircleAvatar(
                          radius: 25,
                          backgroundColor:ColorResource.instance.orangeGradientColor1,
                          child: Text(
                            HelperFunction.getName(),
                            style: StyleResource.instance.styleSemiBold(
                              25,
                              Colors.white,
                            ),
                          )
                      )
                      )
                      ),

                      // YInkwell(onTap: ()=>Get.find<RootViewController>().scaffoldKey.currentState!.openDrawer(),child: YRoundedImage( border: Border.all(color: Colors.white, width: 2,),borderRadius: 25,imageUrl: "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png",height: 50,width: 50,)),
                      Gap(DimensionResource.marginSizeSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${"hello".tr}, ${Get.find<AuthService>().user.value.name}!",style: StyleResource.instance.styleMedium(DimensionResource.fontSizeLarge, ColorResource.instance.white),),
                            YRoundedContainer(
                              radius: 15,
                              padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeSmall,vertical: DimensionResource.paddingSizeExtraSmall),
                              backgroundColor: ColorResource.instance.black.withValues(alpha: 0.5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(ImageResource.instance.locationPinIcon,height: 15,),
                                  Gap(DimensionResource.marginSizeExtraSmall),
                                  Flexible(child: Text(Get.find<AuthService>().user.value.countryName ?? "${Get.find<AuthService>().userIp.value.city},${Get.find<AuthService>().userIp.value.regionName}",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraSmall, ColorResource.instance.white),maxLines: 1,overflow: TextOverflow.ellipsis,))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildNotificationBox(controller)
                    ],
                  ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              color: Colors.transparent, // glass effect
                            ),
                          ),
                        ),

                        YRoundedContainer(
                          onTap: () => Get.toNamed(Routes.searchScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),
                          backgroundColor:
                          ColorResource.instance.btnGreenColor.withValues(alpha: 0.32),
                          borderColor: ColorResource.instance.borderLiteGreen.withValues(alpha: 0.2),
                          radius: 25,
                          showBorder: true,
                          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
                          child: Row(
                            children: [
                              Image.asset(
                                ImageResource.instance.searchIcon,
                                height: 18,
                                color: ColorResource.instance.white,
                              ),
                              Gap(DimensionResource.marginSizeDefault),
                              Text(
                                "search_plants_by_name".tr,
                                style: StyleResource.instance.styleRegular(
                                  DimensionResource.fontSizeSmall,
                                  ColorResource.instance.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                    if((Get.find<AuthService>().user.value.name?.trim().toLowerCase() == "user"))
                    YRoundedContainer(
                      onTap: ()=>Get.toNamed(Routes.editProfileScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),
                      radius: 4,
                      backgroundColor: HelperFunction.hexToColor("#FEE2E2").withValues(alpha: 0.9),
                      padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,color: ColorResource.instance.darkRedColor.withValues(alpha: 0.5),size: 20,weight: 3,),
                          Gap(DimensionResource.paddingSizeSmall),
                          Flexible(child: Text("complete_profile_error".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, HelperFunction.hexToColor(Get.find<AuthService>().user.value.subscribe?.textColor??"#FFFFFF")),))
                        ],
                      ),
                    ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                  if(Get.find<AuthService>().user.value.subscribe?.text?.isNotEmpty??false)
                    YRoundedContainer(
                      radius: 4,
                      backgroundColor: HelperFunction.hexToColor(Get.find<AuthService>().user.value.subscribe?.bgColor??"#FFFFFF").withValues(alpha: 0.9),
                      padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
                      child: Row(

                        children: [
                          CachedNetworkImageWidget(imageUrl: Get.find<AuthService>().user.value.subscribe?.icon ?? "",height: 18,),
                          Gap(DimensionResource.paddingSizeSmall),
                          Flexible(child: Text(Get.find<AuthService>().user.value.subscribe?.text ?? "",style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, HelperFunction.hexToColor(Get.find<AuthService>().user.value.subscribe?.textColor??"#FFFFFF")),))
                        ],
                      ),
                    ).paddingOnly(bottom: DimensionResource.marginSizeDefault),
                  SizedBox(
                    height: 300,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: YRoundedContainer(
                            onTap: () {
                              if((Get.find<AuthService>().user.value.name?.trim().toLowerCase() == "user")){
                                controller.completeProfile();
                              }else{
                                controller.scanType.value = 1;
                                controller.diagnoseTap();
                              }

                            },
                            height: 300,
                            backgroundColor: ColorResource.instance.cardOrangeColor,
                            showBorder: true,
                            borderColor: ColorResource.instance.white,
                            padding: EdgeInsets.only(left : DimensionResource.paddingSizeSmall,right: DimensionResource.paddingSizeSmall,top: DimensionResource.paddingSizeSmall),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "diagnose".tr,
                                      style: StyleResource.instance
                                          .styleBold(
                                        DimensionResource.fontSizeLarge,
                                        ColorResource.instance.white,
                                      )
                                          .copyWith(
                                        fontFamily: FontResource.instance.secondaryFont,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      "check_your_plants_health".tr,
                                      style: StyleResource.instance.styleRegular(
                                        DimensionResource.fontSizeSmall - 2,
                                        ColorResource.instance.white,
                                      ),
                                    ),
                                    const Gap(10),
                                    YRoundedContainer(
                                      radius: 25,
                                      backgroundColor: ColorResource.instance.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: DimensionResource.paddingSizeSmall,
                                        vertical: DimensionResource.paddingSizeExtraSmall,
                                      ),
                                      child: Text(
                                        "scan_for_issues".tr,
                                        style: StyleResource.instance.styleRegular(
                                          DimensionResource.fontSizeExtraSmall,
                                          ColorResource.instance.textColor_11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Image.asset(
                                  ImageResource.instance.homeCardImage1,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Gap(DimensionResource.marginSizeDefault),


                        Expanded(
                          child: Column(
                            children: [

                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: YInkwell(
                                  onTap: () {
                                    if((Get.find<AuthService>().user.value.name?.trim().toLowerCase() == "user")){
                                    controller.completeProfile();
                                    }else {
                                      controller.scanType.value = 2;
                                      controller.diagnoseTap();
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      YRoundedContainer(
                                        height: 145,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),
                                        showBorder: true,
                                        borderColor: ColorResource.instance.white,
                                        gradient: const LinearGradient(
                                          colors: [Color(0xffFBF705), Color(0xff2D8100)],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "identify".tr,
                                                  style: StyleResource.instance
                                                      .styleBold(
                                                    DimensionResource.fontSizeDefault,
                                                    ColorResource.instance.textDarkGreenColor,
                                                  )
                                                      .copyWith(
                                                    fontFamily:
                                                    FontResource.instance.secondaryFont,
                                                  ),
                                                ),
                                                const Gap(4),
                                                Text(
                                                  "identify_any_plant_instantly".tr,
                                                  style: StyleResource.instance.styleRegular(
                                                    DimensionResource.fontSizeSmall - 2,
                                                    ColorResource.instance.textDarkGreenColor2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            YRoundedContainer(
                                              radius: 25,
                                              backgroundColor:
                                              ColorResource.instance.white,
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                DimensionResource.paddingSizeSmall,
                                                vertical:
                                                DimensionResource.paddingSizeExtraSmall,
                                              ),
                                              child: Text(
                                                "check".tr,
                                                style: StyleResource.instance.styleRegular(
                                                  DimensionResource.fontSizeExtraSmall,
                                                  ColorResource.instance.textDarkGreenColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Positioned(
                                        bottom: 0,
                                        right: 7,
                                        child: Image.asset(
                                          ImageResource.instance.homeCardImage2,
                                          height: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Gap(10),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: YInkwell(
                                  onTap: () => Get.toNamed(Routes.myNurseryScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),
                                  child: Stack(
                                    children: [
                                      YRoundedContainer(
                                        height: 145,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(DimensionResource.paddingSizeSmall),

                                        showBorder: true,
                                        borderColor: ColorResource.instance.white,
                                        gradient: const LinearGradient(
                                          colors: [Color(0xff5AFF00), Color(0xff3DAD00)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "my_nursery".tr,
                                                  style: StyleResource.instance
                                                      .styleBold(
                                                    DimensionResource.fontSizeDefault,
                                                    ColorResource.instance.textDarkGreenColor,
                                                  )
                                                      .copyWith(
                                                    fontFamily:
                                                    FontResource.instance.secondaryFont,
                                                  ),
                                                ),
                                                const Gap(4),
                                                Text(
                                                  "check_your_digital_nursery".tr,
                                                  style: StyleResource.instance.styleRegular(
                                                    DimensionResource.fontSizeSmall-2,
                                                    ColorResource.instance.textDarkGreenColor2,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            YRoundedContainer(
                                              radius: 25,
                                              backgroundColor:
                                              ColorResource.instance.white,
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                DimensionResource.paddingSizeSmall,
                                                vertical:
                                                DimensionResource.paddingSizeExtraSmall,
                                              ),
                                              child: Text(
                                                "check".tr,
                                                style: StyleResource.instance.styleRegular(
                                                  DimensionResource.fontSizeExtraSmall,
                                                  ColorResource.instance.textDarkGreenColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),


                                      Positioned(
                                        bottom: 0,
                                        right: 2,
                                        child: Image.asset(
                                          ImageResource.instance.homeCardImage3,
                                          height: 95,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ).paddingOnly(bottom: DimensionResource.marginSizeLarge) ,

          /// trending plants
          controller.isTrendingLoading.value ? TrendingHomeShimmer() : Column(children: [
          SectionHeading(title: "trending".tr, showSubTitle: false,actionButtonText: "view_all".tr,onPressed: ()=>Get.toNamed(Routes.trendingScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),).paddingOnly(bottom: DimensionResource.marginSizeExtraSmall),
          ListViewHorizontalSlider(length: controller.trendingPlantData.value.data.data?.length ?? 0, items: (int index) {
            SearchPlantData data =  controller.trendingPlantData.value.data.data?[index]??SearchPlantData();
            return TrendingPlantCard(
              title: data.commonName ?? "N/A",
              subtitle: data.scientificName ?? "N/A",
              image: data.image ?? "",
              onTap: () => Get.toNamed(Routes.plantsDetailScreen,arguments: {"id":data.id,"type":1})?.then((e){ Get.find<RootViewController>().getUserProfile(); }),
            ).paddingOnly(right: DimensionResource.marginSizeDefault);
          },).paddingOnly(bottom: DimensionResource.marginSizeDefault),
          ]),
          Divider(color: ColorResource.instance.textColor_9.withValues(alpha: 0.1),).paddingSymmetric(vertical: DimensionResource.marginSizeSmall),

          /// plant index
          controller.isPlantIndexLoading.value ? TrendingHomeShimmer() : Column(children: [
            SectionHeading(title: "plant_index".tr, showSubTitle: false,actionButtonText: "view_all".tr,onPressed: ()=>Get.toNamed(Routes.plantIndexScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),).paddingOnly(bottom: DimensionResource.marginSizeSmall),
            Obx(()=> StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              children: List.generate(3 , (index) {
                final item = controller.plantIndexData.value.data.data?[index];
                return StaggeredGridTile.fit(
                  crossAxisCellCount: index== 0  ? 2 : 1,
                  child: PlantIndexCard(
                      imageUrl: item?.image??"",
                      title: item?.name ?? "",
                      isNetworkImage: true,
                      // height: item["height"].toDouble(),
                      width: double.infinity,
                      isSelected: false,
                      onTap: ()=> Get.toNamed(Routes.plantIndexScreen,arguments: {"type":2,"data":item})?.then((e){ Get.find<RootViewController>().getUserProfile(); })
                  ),
                );
              },
              ),
            ),).paddingOnly(bottom: DimensionResource.marginSizeDefault,left: DimensionResource.marginSizeDefault,right: DimensionResource.marginSizeDefault),
          ]),
          Divider(color: ColorResource.instance.textColor_9.withValues(alpha: 0.1),).paddingSymmetric(vertical: DimensionResource.marginSizeSmall),

          /// Articles
          controller.isArticlesLoading.value ? TrendingHomeShimmer() : Column(children: [
            SectionHeading(title: "articles".tr, showSubTitle: false,actionButtonText: "view_all".tr,onPressed: ()=>Get.toNamed(Routes.articlesScreen)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),),
            ListViewHorizontalSlider(length: controller.articleListData.value.data.data?.length??0, items: (int index) {
              return ArticlesCard(
                onPressed: () => Get.toNamed(Routes.articlesDetailScreen, arguments: controller.articleListData.value.data.data?[index],)?.then((e){ Get.find<RootViewController>().getUserProfile(); }),
                imageUrl:  controller.articleListData.value.data.data?[index].image??"",
                width: HelperFunction.screenWidth() * .50,
                title: controller.articleListData.value.data.data?[index].title??"" ?? '',
              ).paddingOnly(right: DimensionResource.marginSizeDefault);
            },).paddingOnly(left: DimensionResource.marginSizeDefault,bottom: DimensionResource.marginSizeDefault),
          ]),

          Divider(color: ColorResource.instance.textColor_9.withValues(alpha: 0.1),).paddingSymmetric(vertical: DimensionResource.marginSizeSmall),

          /// Tips
          controller.isTipsLoading.value ? TrendingHomeShimmer() : Column(children: [
            SectionHeading(title: "get_knowledge_about_plants".tr, showSubTitle: false,actionButtonText: "",showActionButton: false,),
            ListViewHorizontalSlider(length: controller.tipsList.value.data.length, items: (index){
              return TipsCard(
                imageUrl: HelperFunction.getTipsRandomImage()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 ,
                title: 'tips'.tr,
                subtitle: controller.tipsList.value.data[index].title??"",
              ).paddingOnly(right: DimensionResource.marginSizeSmall);
            },).paddingOnly(left:DimensionResource.marginSizeSmall,right:DimensionResource.marginSizeSmall,bottom: DimensionResource.marginSizeSmall),
          ]),

          Gap(100)

        ],
      ),
    ),
  );

}
class TipsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const TipsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      onTap: onTap,
      padding: EdgeInsets.all(DimensionResource.marginSizeExtraSmall),
      backgroundColor: ColorResource.instance.white,
      radius: 5,
      width: HelperFunction.screenWidth(),
      showBorder: true,
      borderColor: ColorResource.instance.lightGrey.withValues(alpha: .2),
      boxshadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [

          YRoundedImage(
            imageUrl: imageUrl,
            isNetworkImage: false,
            height: 120,
            width: HelperFunction.screenWidth(),
            fit: BoxFit.cover,
          ),


          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
          ),


          Positioned(
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StyleResource.instance.styleBold(
                    DimensionResource.fontSizeSmall,
                    ColorResource.instance.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: StyleResource.instance.styleRegular(
                    DimensionResource.fontSizeSmall,
                    ColorResource.instance.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildNotificationBox(HomeController controller){
  return Obx(()=>Stack(
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorResource.instance.black.withValues(alpha: 0.4),
            boxShadow: DecorationResource.instance.containerBoxShadow()
        ),
        child:buildIconButton(image: ImageResource.instance.bellIcon, onTap: (){},height: 35),
      ).paddingAll(DimensionResource.marginSizeSmall),
      if((Get.find<AuthService>().user.value.notificationCount??0) > 0)
        Positioned(top: 5,
          right: 5,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),

              color: ColorResource.instance.white,
            ),
            child: Center(
              child: Text(
                  Get.find<AuthService>().user.value.notificationCount.toString() ??"", style: StyleResource.instance.styleSemiBold(9, ColorResource.instance.btnGreenColor)
              ),
            ),
          ),
        ),
      InkWell(
        onTap: (){
          Get.toNamed(Routes.notificationScreen)?.then((e){
            if (Get.isRegistered<RootViewController>()) {
              Get.find<RootViewController>().getUserProfile();
            }
          });
        },
        child:const  SizedBox(
          height: 40,
          width: 40,
        ),
      )
    ],
  )
  );
}


Widget buildIconButton({required String image,required VoidCallback onTap, AlignmentGeometry? alignmentGeometry,double ?height}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: height??40,
      width: height??40,
      child: Align(
          alignment: alignmentGeometry ?? Alignment.center,
          child: Image.asset(
            image,
            height: (height??40)/1.5,
          )),
    ),
  );
}




class ArticlesCard extends StatelessWidget {
  const ArticlesCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.height = 200,
    this.borderRadius = 8,
    this.textPadding = const EdgeInsets.only(left: 10, bottom: 8),  this.onPressed, this.width,
  });

  final String imageUrl;
  final String title;
  final double height;
  final double? width;

  final double borderRadius;
  final EdgeInsets textPadding;
  final VoidCallback? onPressed;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [

          YRoundedImage(
            imageUrl: imageUrl,
            height: height,
            width: width ?? HelperFunction.screenWidth(),
            fit: BoxFit.cover,
          ),


          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),


          Positioned(
            bottom: 10,
            left: 3,
            right: 3,
            child: Padding(
              padding: textPadding,
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: StyleResource.instance.styleSemiBold(
                  DimensionResource.fontSizeSmall,
                  ColorResource.instance.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class TrendingPlantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback? onTap;
  final double width;


  const TrendingPlantCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
    this.width = 200,

  });

  @override
  Widget build(BuildContext context) {
    return YRoundedContainer(
      onTap: onTap,
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
      backgroundColor: ColorResource.instance.white,
      radius: 5,
      width: width,
      height: 234,
      showBorder: true,
      borderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
      boxshadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
      child: Column(
        children: [

          Stack(
            children: [
              YRoundedImage(
                isNetworkImage: image.startsWith('http'),
                imageUrl: image,
                borderRadius: 0,
                height: 150,
                width: 200,
                fit: BoxFit.cover,
                backgroundColor:
                ColorResource.instance.cardBgGreenColor.withValues(alpha: 0.40),
                padding:
                EdgeInsets.all(DimensionResource.paddingSizeSmall),
              ).paddingOnly(
                  bottom: DimensionResource.marginSizeDefault),
              Positioned(
                top: 15,
                left: 15,
                child: YRoundedContainer(
                  padding: EdgeInsets.symmetric(horizontal: DimensionResource.paddingSizeSmall - 1,vertical: DimensionResource.paddingSizeExtraSmall - 1),
                  backgroundColor: ColorResource.instance.black.withValues(alpha: .5),
                  child: Text("popular".tr,style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall - 2 , ColorResource.instance.white),),
                ),
              )
            ],
          ),


          Text(
            title,
            style: StyleResource.instance.styleSemiBold(
              DimensionResource.fontSizeDefault,
              ColorResource.instance.textDarkGreenColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),


          Text(
            subtitle,
            style: StyleResource.instance.styleRegular(
              DimensionResource.fontSizeSmall,
              ColorResource.instance.textColor_2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }



}
