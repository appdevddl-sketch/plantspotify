

import 'package:plants_spotify/view/screens/auth_view/profile_screen/complete_profile_screen/complete_profile_screen.dart';
import 'package:plants_spotify/view/screens/auth_view/profile_screen/edit_profile/edit_profile_screen.dart';
import 'package:plants_spotify/view/screens/auth_view/profile_screen/profile_screen/profile_screen.dart';
import 'package:plants_spotify/view/screens/auth_view/social_signIn_screen/social_signIn_screen.dart';
import 'package:plants_spotify/view/screens/initial_view/splash_screen.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/account_view_screen.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/app_html_content/app_html_content.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/contact_us_screen/contact_us_screen.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/help_screen/help_screen.dart';
import 'package:plants_spotify/view/screens/root_view/account_view/rating_screen/rating_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/articles_screen/articles_detail_view/articles_detail_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/articles_screen/articles_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/diagnose_detail_screen/diagnose_detail_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/image_too_blurry/image_too_blurry_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/plant_not_found/plant_not_found_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/diagnose_screens/questions_screen/questions_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:get/get.dart' show GetPage;
import 'package:plants_spotify/view/screens/auth_view/app_content.dart';
import 'package:plants_spotify/view/screens/on_board/on_board_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/notification_screen/notification_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/create_collection/create_collection_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_detail_view/plant_detail_view.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/plant_index_screen/plant_index_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/scan_history_screen/scan_history_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/search_screen/search_screen.dart';
import 'package:plants_spotify/view/screens/root_view/home_view/trending_screen/trending_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/collectionviewSceen/collectionviewSceen.dart';
import 'package:plants_spotify/view/screens/root_view/my_nursery_view/my_nursery_screen.dart';
import 'package:plants_spotify/view/screens/root_view/my_plants_screen/my_plants_screen.dart';
import 'package:plants_spotify/view/screens/root_view/root_view.dart';
import 'package:plants_spotify/view/screens/root_view/subscription_view/subscription%20screen.dart';





part 'app_routes.dart';

class AppPages {
  static final routes = [

    /// on board screen
    GetPage(name: Routes.onBoardScreen, page: ()=>const OnBoardScreen()),

    /// inital Screen
    GetPage(name: Routes.splashScreen, page: ()=>const SplashScreen()),

    /// auth view
    GetPage(name: Routes.socialSignInScreen, page: ()=>const SocialSigninScreen()),
    GetPage(name: Routes.completeProfileScreen, page: ()=>const CompleteProfileScreen()),
    GetPage(name: Routes.profileScreen, page: ()=>const ProfileScreen()),
    GetPage(name: Routes.editProfileScreen, page: ()=>const EditProfileScreen()),



    ///


    /// root view
    GetPage(name: Routes.rootView, page: ()=> RootView()),
    GetPage(name: Routes.homeView, page: ()=>const HomeViewScreen()),
    GetPage(name: Routes.searchScreen, page: ()=>const SearchScreen()),
    GetPage(name: Routes.trendingScreen, page: ()=>const TrendingScreen()),
    GetPage(name: Routes.plantIndexScreen, page: ()=>const PlantIndexScreen()),
    GetPage(name: Routes.questionsScreen, page: ()=>const QuestionsScreen()),
    GetPage(name: Routes.imageTooBlurryScreen, page: ()=>const ImageTooBlurryScreen()),
    GetPage(name: Routes.plantNotFoundScreen, page: ()=>const PlantNotFoundScreen()),
    GetPage(name: Routes.subscriptionScreen, page: ()=>const SubscriptionScreen()),
    GetPage(name: Routes.plantsDetailScreen, page: ()=>const PlantDetailView()),
    GetPage(name: Routes.createCollectionScreen, page: ()=>const CreateCollectionScreen()),
    GetPage(name: Routes.myNurseryScreen, page: ()=>const MyNurseryScreen()),
    GetPage(name: Routes.myCollectionScreen, page: ()=>const CollectionViewScreen()),
    GetPage(name: Routes.scanHistoryScreen, page: ()=>const ScanHistoryScreen()),
    GetPage(name: Routes.notificationScreen, page: ()=>const NotificationScreen()),
    GetPage(name: Routes.accountViewScreen, page: ()=>const AccountViewScreen()),
    GetPage(name: Routes.articlesScreen, page: ()=>const ArticlesScreen()),
    GetPage(name: Routes.articlesDetailScreen, page: ()=>const ArticlesDetailScreen()),
    GetPage(name: Routes.diagnosticsDetailScreen, page: ()=>const DiagnoseDetailScreen()),
    GetPage(name: Routes.myPlantsScreen, page: ()=>const MyPlantsScreen()),














    /// Account View Drawer





    // order section





    /// map routes



    /// Redeem




    /// account option
    GetPage(name: Routes.appContentScreen, page: ()=>const AppContentScreen()),
    GetPage(name: Routes.contactUsScreen, page: ()=>const ContactUsScreen()),
    GetPage(name: Routes.helpScreen, page: ()=>const HelpScreen()),

    GetPage(name: Routes.htmlContentView, page: ()=>const AppHtmlContent()),






  /// Mall Page






  ];
}
