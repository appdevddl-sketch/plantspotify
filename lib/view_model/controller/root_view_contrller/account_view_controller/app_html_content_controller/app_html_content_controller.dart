
import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/accountview_models/cms_model.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/articel_list_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/account_option_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AppHtmlContentController extends BaseViewController{
  AccountOptionProvider accountOptionProvider = getIt();
  Map<String,dynamic> backData ={};
  RxInt progressCount =0.obs;
  final WebViewController controllerWv = WebViewController();
  @override
  void onInit() async{
    backData=Get.arguments??{};
    backData.logPrint();
    await getCmsData();
    super.onInit();
  }

  /// get cms data
  Rx<SingleResponse<CmsModel>> cmsData = SingleResponse<CmsModel>(data: CmsModel()).obs;
  Future getCmsData() async {
    try {
      isLoading.call(true);
      await accountOptionProvider.getCms(onError: (errorMessage) {
        
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        cmsData.value = SingleResponse<CmsModel>.fromJson(data??{}, (data) => CmsModel.fromJson(data));
        isLoading.call(false);

      });
    } catch (e) {
      isLoading.call(false);
      (e).logPrint();
    }
  }
}