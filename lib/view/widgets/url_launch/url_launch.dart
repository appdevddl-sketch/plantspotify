import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:url_launcher/url_launcher.dart';


enum LunchUrl{browser,email,phone,lunch,whatsapp }

class UrlLaunch{
  static UrlLaunch ?_instance;
  static UrlLaunch get instance => _instance??= UrlLaunch();

  launchUrlFunction({required String path,required LunchUrl type,String ?phoneNo,String ?message })async{
    ("path =>$path,type=>$type").logPrint();
    switch(type){
      case LunchUrl.browser:await launch(path);
      break;
      case LunchUrl.email:await launch("mailto:$path",);
      break;
      case LunchUrl.phone:await launch("tel:$path");
      break;
      case LunchUrl.lunch:await launchUrl(Uri.parse(path));
      break;
      case LunchUrl.whatsapp:await launchUrl(Uri.parse("whatsapp://send?phone=${'+'}$phoneNo&text=${Uri.encodeComponent(message??"")}"));
      break;
      default: {
        ("something want wrong").logPrint();
      }
      break;
    }
  }
}

