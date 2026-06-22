

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../loader_helper/loader_helper_ui.dart';
import '../text_field_view/regex/regex.dart';


class PaginationView<T> extends StatelessWidget {
  final List<T> showItemList;
  final Widget Function(BuildContext context, int index , T itemData) mainView;
  final EdgeInsets ?sidePadding;
  final Axis? scrollDirection;
  final bool? isWrap;
  final PaginationViewController<T> pagingScrollController;
  final Function onRefresh;
  final Widget ? subWidget;
  final bool isGrid;
  final bool isCustomScrollController;
  final ScrollPhysics? gridPhysics;

  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double? mainAxisExtent;
  const PaginationView({super.key, required this.showItemList,required this.mainView, this.sidePadding, this.scrollDirection,required this.pagingScrollController,required this.onRefresh, this.isWrap, this.subWidget, this.isGrid = false, this.crossAxisCount = 2, this.mainAxisSpacing = 10, this.crossAxisSpacing = 10, this.mainAxisExtent, this.gridPhysics,  this.isCustomScrollController = false,});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: ColorResource.instance.mainColor,
      backgroundColor: ColorResource.instance.white,
      onRefresh: ()async{
        pagingScrollController.currentPage.value=1;
        pagingScrollController.totalPageCont=1;
        pagingScrollController.isLoading.value=false;
        onRefresh.call();
      },
      child: (){
        if(isWrap==true){
          return SingleChildScrollView(
            controller: pagingScrollController.scrollController,
            physics:const AlwaysScrollableScrollPhysics(),
            padding: sidePadding??EdgeInsets.zero,
            scrollDirection: scrollDirection ?? Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Wrap(
                  alignment : WrapAlignment.start,
                  runAlignment : WrapAlignment.start,
                  children: List.generate(showItemList.length, (index) => mainView(context, index , pagingScrollController.itemList.elementAt(index))),),
                Obx(()=>Center(
                  child: Padding(
                    padding:const EdgeInsets.only(bottom: 20.0,top: 10),
                    child: Visibility(
                      visible: pagingScrollController.isLoading.value,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Loading".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),),
                          const SizedBox(width: DimensionResource.marginSizeExtraSmall,),
                          loaderHelperUi(radius: 10,loaderColor: ColorResource.instance.black)
                        ],
                      ),
                    ),
                  ),
                )),
                subWidget??const SizedBox()
              ],
            ),
          );
        }else{
          return  isGrid ? _buildGrid() : ListView(
            controller: pagingScrollController.scrollController,
            physics:const AlwaysScrollableScrollPhysics(),
            padding: sidePadding??EdgeInsets.zero,
            scrollDirection: scrollDirection ?? Axis.vertical,
            children: [
              ...List.generate(showItemList.length, (index) => mainView(context, index , pagingScrollController.itemList.elementAt(index))),
              Obx(()=>Padding(
                padding:const EdgeInsets.only(bottom: 20.0,top: 10),
                child: Visibility(
                  visible: pagingScrollController.isLoading.value,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading".tr,style: StyleResource.instance.styleSemiBold(DimensionResource.fontSizeLarge, ColorResource.instance.black),),
                      const SizedBox(width: DimensionResource.marginSizeExtraSmall,),
                      loaderHelperUi(radius: 10,loaderColor: ColorResource.instance.black)
                    ],
                  ),
                ),
              )),
              subWidget??const SizedBox()
            ],
          );
        }
      }(),
    );
  }
  Widget _buildGrid() {
    return Obx(() => GridView.builder(
            controller: isCustomScrollController ? null :  pagingScrollController.scrollController,
            padding: sidePadding ?? EdgeInsets.zero,
            shrinkWrap: true,
            physics: gridPhysics ?? const AlwaysScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisExtent: mainAxisExtent,
            ),
            itemCount: showItemList.length +
                (pagingScrollController.isLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if(index == showItemList.length){
                return Center(child: loaderHelperUi(radius: 10,loaderColor: ColorResource.instance.black));
              }
              return mainView(context, index, showItemList[index]);
            },
          ),
    );
  }

}

class PaginationViewController<T>{
  int totalPageCont;
  Function(bool,int) onScrollDownDone;
  String ?showMessage;
  RxInt currentPage= 1.obs;
  RxBool isLoading= false.obs;
  RxList<T> itemList = <T>[].obs;

  ScrollController scrollController = ScrollController();
  PaginationViewController({required this.totalPageCont,required this.onScrollDownDone,this.showMessage,required this.itemList}){
    scrollController.addListener(_addListener);
  }


  get _addListener =>(){
    if(scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (scrollController.position.maxScrollExtent  == scrollController.position.pixels) {
        currentPage++;
        (currentPage).logPrint();
        if (totalPageCont >= currentPage.value) {
          onScrollDownDone(true,currentPage.value);
        }else{
          onScrollDownDone(false,currentPage.value);
          // toastShow(massage: showMessage??"No More data found yet.");
        }
      }
    }
  };
}


