


import 'package:get/get.dart';
import 'package:plants_spotify/model/model/root_view_models/home_view_models/notification_model.dart';
import 'package:plants_spotify/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:plants_spotify/model/network_calls/dio_client/base_response.dart';
import 'package:plants_spotify/model/network_calls/dio_client/get_it_instance.dart';
import 'package:plants_spotify/view/screens/base_view/base_view_screen.dart';
import 'package:plants_spotify/view/widgets/pagination_view/pagination_view_screen.dart';
import 'package:plants_spotify/view/widgets/text_field_view/regex/regex.dart';
import 'package:plants_spotify/view/widgets/toast_view/showtoast.dart';



class NotificationScreenController extends BaseViewController {

  HomeProvider homeProvider = getIt();

  /// get plant collection data
  Rx<SingleResponse<NotificationModel>> notificationData = SingleResponse<NotificationModel>(data: NotificationModel()).obs;
  PaginationViewController<NotificationData> notificationPaginationViewController = PaginationViewController(
      showMessage: "no_data_found".tr,
      totalPageCont: 0,
      onScrollDownDone: (bool value, int pageNumber) {},
      itemList: <NotificationData>[].obs
  );
  Future getNotificationList({required int pageNumber,required bool forPaginate}) async {
    try {
      if(forPaginate){
        notificationPaginationViewController.isLoading.call(true);
      } else {
        notificationPaginationViewController.itemList.clear();
        notificationData.value = SingleResponse<NotificationModel>(data: NotificationModel());
      }
      Map<String, dynamic> getNotificationsData ={
        "paginate": 10,
        "page":pageNumber
      };
      await homeProvider.getNotifications(getNotificationsData,onError: (errorMessage) {
        
        toastShow(message: errorMessage??"", error: true);
        ("error Message=> $errorMessage").logPrint();
      }, onSuccess: (message, data) async {
        if(data!= null){
          notificationData.value = SingleResponse<NotificationModel>.fromJson(data??{}, (data) => NotificationModel.fromJson(data));
          notificationPaginationViewController.totalPageCont = notificationData.value.data.pagination?.lastPage ?? 0;
          notificationPaginationViewController.onScrollDownDone = (bool value, int pageNumber) {
            if (value) {
              getNotificationList(pageNumber: pageNumber,forPaginate: true);
            }
          };
          if(forPaginate){
            notificationPaginationViewController.itemList.addAll(notificationData.value.data.notifications ?? []);
            notificationPaginationViewController.isLoading.call(false);
          }else{
            notificationPaginationViewController.itemList.value = notificationData.value.data.notifications ?? [];
          }
        }
      });
    } catch (e) {
      (e).logPrint();
      notificationPaginationViewController.isLoading.call(false);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit

    getNotificationList(pageNumber: 1, forPaginate: false);
    super.onInit();
  }

}
