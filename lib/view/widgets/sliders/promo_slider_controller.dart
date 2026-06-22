import 'package:get/get.dart';

class PromoSliderController extends GetxController{
  static PromoSliderController get instance => Get.find();
  final carouselCurrentIndex = 0.obs;
  void updatePageIndicator(index){
    carouselCurrentIndex.value=index;
  }
}