class ImageResource {
  static ImageResource? _instance;
  static ImageResource get instance => _instance ??= ImageResource._init();
  ImageResource._init();

  String toOnboard(String name) => 'assets/images/on_board/$name';
  String toIcons(String name) => 'assets/images/icons/$name';
  String toViewImage(String name) => 'assets/images/view_images/$name';

  String toPlaceholderAndError(String name) => 'assets/images/placeholder_and_error/$name';
  String toAppLogo(String name) => 'assets/images/app_logo/$name';
  String toLottie(String name) => 'assets/images/lottie_file/$name';
  String toGif(String name) => 'assets/images/toGif/$name';



  /// app logo
  String get appColorLogo => toAppLogo('prestige_logo_new.png');


  /// on_board
  String get onBoardFirst => toOnboard('onboard1.png');
  String get onBoardSecond => toOnboard('onboard2.png');
  String get onBoardThird => toOnboard('onboard3.png');

  /// place holder
  String get placeholderImage => toPlaceholderAndError('placeholderImage.gif');
  String get errorImage => toPlaceholderAndError('error.webp');

  ///icons
  // String get homeIcon => toIcons('home_icon.png');
  // String get userIcon => toIcons('user.png');
  String get checkIcon => toIcons('check_icon.png');
  String get errorIcon  => toIcons('error.png');
  String get forwardArrowIcon  => toIcons('forward_arrow.png');
  // String get closeIcon  => toIcons('close.png');
  String get indiaFlagIcon  => toIcons('indiaflag.png');
  // String get locationIcon  => toIcons('location.png');
  String get rewardsIcon  => toIcons('rewards.png');
  String get ordersIcon  => toIcons('orders.png');
  String get drawerIcon  => toIcons('drawer.png');
  String get notificationBellIcon  => toIcons('notification_bell.png');
  String get moreIcon  => toIcons('more.png');
  String get emailFlagIcon => toIcons('email.png');

  String get sliderIcon => toIcons('sliders.png');
  String get sendIcon => toIcons('send.png');
  String get markerIcon => toIcons('marker.png');
  // String get searchIcon => toIcons('search.png');
  String get offerIcon => toIcons('discount.png');
  String get calenderIcon => toIcons('calendar.png');
  String get buttonIcon => toIcons('slider_button.png');
  String get rewardCoinIcon => toIcons('reward_coin.png');
  String get chatBotIcon => toIcons('chatbot.png');
  String get copyIcon => toIcons('copy.png');
  String get addIcon => toIcons('add.png');
  String get scanIcon => toIcons('scan.png');
  // String get clockIcon => toIcons('clock.png');
  String get invoiceIcon => toIcons('invoice.png');
  String get productDetailIcon => toIcons('product_details.png');
  String get userSolidIcon => toIcons('user_solid.png');
  String get wishlistIcon => toIcons('wishlist.png');
  String get imageIcon => toIcons('image_icon.png');
  String get ratingIcon => toIcons('rate.png');
  String get storeIcon => toIcons('store.png');


  String get mailIcon => toIcons('mail.png');
  String get documentIcon => toIcons('document.png');
  String get commentIcon => toIcons('comments.png');
  // String get bellIcon => toIcons('bell.png');
  String get profileIcon => toIcons('user.png');
  String get logout => toIcons('logout.png');
  String get lockIcon => toIcons('lock.png');
  String get pickupIcon => toIcons('pickup.png');
  String get callIcon => toIcons('call.png');
  String get locationColoredIcon => toIcons('location_colored.png');
  String get locationDetailIcon => toIcons('location_detail.png');
  String get pickupDetailIcon => toIcons('pickup_detail.png');
  String get dropOffDetailIcon => toIcons('drop_off.png');
  String get cartIcon => toIcons('cart.png');
  String get paymentTypeIcon => toIcons('payment_type.png');
  String get meterIcon => toIcons('meter.png');


  String get appleIcon => toIcons('apple_icon.png');
  String get googleIcon => toIcons('google_icon.png');
  String get homeIcon => toIcons('home_icon.png');
  String get plantIcon => toIcons('plant_icon.png');
  String get searchIcon => toIcons('search_icon.png');
  String get userIcon => toIcons('user_icon.png');
  String get locationPinIcon => toIcons('location_pin_icon.png');
  String get bellIcon => toIcons('bell_icon.png');
  String get backArrowIcon  => toIcons('back_arrow_icon.png');
  String get homeDrop  => toIcons('home_drop.png');
  String get closeIcon  => toIcons('close_icon.png');
  String get closeOutlinedIcon  => toIcons('close_outlined.png');
  String get sunIcon  => toIcons('sun_icon.png');
  String get dropIcon  => toIcons('drop_icon.png');
  String get temperatureIcon  => toIcons('temperature_icon.png');
  String get correctIcon  => toIcons('correct_icon.png');
  String get scanOutlinedIcon  => toIcons('scan_outlined_icon.png');
  String get saveIcon  => toIcons('save_icon.png');
  String get collectionIcon  => toIcons('collection_icon.png');
  String get addNoteIcon  => toIcons('add_note_icon.png');
  String get collectionIndicatorIcon  => toIcons('collection_indicator_icon.png');
  String get cameraIcon  => toIcons('camera_icon.png');
  String get notificationBellOutlinedIcon  => toIcons('notification_bell_outlined_icon.png');
  String get editPenIcon  => toIcons('edit_pen_icon.png');
  String get userOutlinedIcon  => toIcons('user_outlined.png');
  String get locationOutlinedIcon  => toIcons('location_outlined.png');
  String get homeOutlinedIcon  => toIcons('home_outlined_icon.png');
  String get shareIcon  => toIcons('share_icon.png');
  String get plantDetailIcon  => toIcons('plant_detail_icon.png');
  String get settingDetailIcon  => toIcons('setting_detail_icon.png');
  String get moreDetailIcon  => toIcons('more_detail_icon.png');
  String get flowerDetailIcon  => toIcons('flower_detail_icon.png');
  String get leafIcon  => toIcons('leaf_icon.png');
  String get heightIcon  => toIcons('height_icon.png');
  String get spreadIcon  => toIcons('spread_icon.png');
  String get colorsIcon  => toIcons('colors_icon.png');
  String get plantTypeIcon  => toIcons('plant_type_icon.png');
  String get scientificIcon  => toIcons('scientific_icon.png');
  String get clockIcon  => toIcons('clock_icon.png');
  String get distributionIcon  => toIcons('distribution_icon.png');
  String get plantingIcon  => toIcons('planting_icon.png');
  String get temperatureDetailIcon  => toIcons('temperature_detail_icon.png');
  String get hardinessDetailIcon  => toIcons('hardiness_detail_icon.png');
  String get sunlightDetailIcon  => toIcons('sunlight_detail_icon.png');
  String get soilDetailRequirementsIcon  => toIcons('soil_detail_requirements.png');
  String get geoLocationDetailIcon  => toIcons('geo_location_detail.png');
  String get medicineDetailIcon  => toIcons('medicine_detail_icon.png');
  String get plantUseDetailIcon  => toIcons('plant_use_detail_icon.png');
  String get ornamentalDetailIcon  => toIcons('ornamental_detail_icon.png');
  String get toxicityDetailIcon  => toIcons('toxicity_detail_icon.png');
  String get careDetailIcon  => toIcons('care_detail_icon.png');
  String get usesDetailIcon  => toIcons('uses_detail_icon.png');
  String get clockOutlinedIcon  => toIcons('clock_outlined_icon.png');
  String get selectedTrueIcon  => toIcons('selected_true_icon.png');
  String get binIcon  => toIcons('bin_icon.png');
  String get editPenOutlined  => toIcons('edit_pen_outlined_icon.png');
  String get logoutIcon  => toIcons('logout_icon.png');
  String get sadPlantIcon  => toIcons('sad_plant_icon.png');
  String get editNoteIcon => toIcons('edit_note_icon.png');
  String get restorePurchaseIcon  => toIcons('restore_purchase_icon.png');
  String get plantTagsIcon  => toIcons('plant_tags_icon.png');
  String get completeProfilePlantIcon  => toIcons('complete_profile_plant_icon.png');
  String get symptomsIcon  => toIcons('symptoms_icon.png');
  String get preventionIcon  => toIcons('prevention_icon.png');
  String get solutionsIcon  => toIcons('solutions_icon.png');
  String get plantDiagnosisIcon  => toIcons('plant_diagnosis_icon.png');
  String get galleryIcon  => toIcons('gallery_icon.png');






































  /// app view Images
  String get clothesImages  => toViewImage('laundry_clothes.png');
  String get leafImage  => toViewImage('leaf.png');
  String get leaf2Image  => toViewImage('leaf2.png');
  String get leaf3Image  => toViewImage('leaf3.png');
  String get appLogoImage  => toViewImage('app_logo.png');
  String get appLogo2Image  => toViewImage('app_logo_2.png');
  String get appLogo3Image  => toViewImage('app_logo_3.png');

  String get plantImage  => toViewImage('plant_image.png');
  String get leaf4Image  => toViewImage('leaf4.png');
  String get leaf5Image  => toViewImage('leaf5.png');
  String get leaf6Image  => toViewImage('leaf6.png');
  String get leaf7Image  => toViewImage('leaf7.png');
  String get leaf8Image  => toViewImage('leaf8.png');
  String get leaf9Image  => toViewImage('leaf9.png');
  String get leaf10Image  => toViewImage('leaf10.png');
  String get leaf11Image  => toViewImage('leaf11.png');
  String get flowerLeaf  => toViewImage('flower_leaf.png');
  String get homeCardImage1  => toViewImage('home_card_image1.png');
  String get homeCardImage2  => toViewImage('home_card_image2.png');
  String get homeCardImage3  => toViewImage('home_card_image3.png');
  String get leafTransparent  => toViewImage('transparent_leaf.png');
  String get cameraImage  => toViewImage('camera.png');
  String get plantNotFoundImage  => toViewImage('plant_not_found.jpg');
  String get imageTooBlurryImage  => toViewImage('image_too_blurry.jpg');
  String get subPlantImage1  => toViewImage('sub_plant_image_1.png');
  String get subPlantImage2  => toViewImage('sub_plant_image_2.png');
  String get subPlantImage3  => toViewImage('sub_plant_image_3.png');
  String get subPlantImage4  => toViewImage('sub_plant_image_4.png');
  String get unTitlePlantsImage  => toViewImage('untitle_plants_icon.png');
  String get indoorPlantsImage  => toViewImage('indoor_plants_icon.png');
  String get outdoorPlantsImage  => toViewImage('outdoor_plants_icon.png');
  String get balconyPlantsImage  => toViewImage('balcony_plants_icon.png');
  String get plant1Image  => toViewImage('plant_1_image.png');
  String get renameImage  => toViewImage('rename_image.png');
  String get deleteImage  => toViewImage('delete_image.png');
  String get leafTransparentImage  => toViewImage('leaf_transparent_bg.png');
  String get leafTransparentVertical  => toViewImage('leaf_transparent_bg_vertical.png');
  String get leaf12  => toViewImage('leaf12.png');
  String get leaf13  => toViewImage('leaf13.png');
  String get indexFlowersImage  => toViewImage('index_flowers_image.png');
  String get indexFruitsImage  => toViewImage('index_fruits_image.png');
  String get indexMedicinalImage  => toViewImage('index_medicinal_image.png');
  String get indexNativeImage  => toViewImage('index_native_image.png');
  String get indexToxicImage => toViewImage('index_toxic_image.png');
  String get indexVegetablesImage  => toViewImage('index_vegetables_image.png');
  String get feedbackDialogImage  => toViewImage('feedback_dialog_image.png');
  String get tip1Image  => toViewImage('tip1_image.png');
  String get tip2Image  => toViewImage('tip2_image.png');
  String get tip3Image  => toViewImage('tip3_image.png');
  String get tip4Image  => toViewImage('tip4_image.png');
  String get tip5Image  => toViewImage('tip5_image.png');
  String get tip6Image  => toViewImage('tip6_image.png');
  String get tip7Image  => toViewImage('tip7_image.png');
  String get tip8Image  => toViewImage('tip8_image.png');
  String get happyPlantImage  => toViewImage('happy_plant_image.png');
















  /// gif
  String get leafLoaderGif  => toGif('leaf_loader.gif');









  /// no data found
  String get noDataFoundImage => toViewImage('not_found_found.gif');
  String get somethingWrongImage => toViewImage('something_wrong.gif');
  String get homeBannerImage => toViewImage('home_banner.png');
  String get bottomBannerBgImage => toViewImage('bottom_banner_bg.png');
  String get mapBgImage => toViewImage('map_bg.png');
  String get successfullyImage => toViewImage('successfully.gif');
  String get helpBgImage => toViewImage('help_bg.png');

  // Lottie Files
  String get noWifiAnimation => toLottie('no_wifi.json');
  String get wifiConnectedAnimation => toLottie('wifi_connected.json');
  String get noDataFoundLottieAnimation => toLottie('data_not_found.json');
  String get dataNotFoundAnimation  => toLottie('data_not_found.json');









  ///  default images
  String get defaultUser  => "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6BAHlIuDPK6lkExHi1DWN6cdzB2OJkmSSMNxEhQXpLnHQ3fslHw7AqUJsZEDvu85xhWw&usqp=CAU";
}
