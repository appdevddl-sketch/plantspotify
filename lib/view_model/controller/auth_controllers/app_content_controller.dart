
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/color_resource.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AppContentController extends BaseViewController{
  Map<String,String> backData ={};
  RxInt progressCount =0.obs;
  final WebViewController controllerWv = WebViewController();
  @override
  void onInit() {
    backData=Get.arguments??{};
    backData.logPrint();
    controllerWv
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ColorResource.instance.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress)=>progressCount.value =progress,
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(backData.containsKey("url")?backData["url"]??"":"https://www.intouchmall.com/"));
    super.onInit();
  }
}