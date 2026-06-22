  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
import 'package:plants_spotify/view/widgets/text_field_view/common_textfield.dart';

  import '../../../model/utils/color_resource.dart';
  import '../../../model/utils/dimensions_resource.dart';
  import '../../../model/utils/style_resource.dart';

  class DropdownButtonHelper<T> extends StatelessWidget {
    final RxList<T> itemList;
    final bool valueSelectedOrNot;
    final Function(T value) onValueChanged;
    final String Function(T value) itemView;
    final String hintText;
    final bool ?showBorder;
    final bool ?isExpanded;
    final Color ?bgColor;
    final Color ?iconColor;
    final Color ?borderColor;
    final double ?height;
    final double ?borderWidth;
    final TextStyle ? selectItemStyle;
    final EdgeInsets ?padding;
    const DropdownButtonHelper({Key? key,required this.itemList,required this.onValueChanged,required this.itemView,required this.hintText,required this.valueSelectedOrNot, this.showBorder, this.bgColor, this.padding, this.isExpanded, this.selectItemStyle, this.iconColor, this.height, this.borderColor, this.borderWidth}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Container(
        height: height??55,
        padding: padding??const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bgColor??ColorResource.instance.white,
            border: Border.all(color: showBorder==false?ColorResource.instance.transparent:borderColor??ColorResource.instance.btnGreenColor, width: borderWidth ?? .5)),
        child: Obx(()=>Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
          ),
          child: DropdownButton<T>(
            dropdownColor: ColorResource.instance.white,
            isExpanded: isExpanded??true,
            icon: const Icon(Icons.keyboard_arrow_down),
            padding: EdgeInsets.zero,
            iconEnabledColor: iconColor??ColorResource.instance.mainColor,
            iconDisabledColor: iconColor??ColorResource.instance.mainColor,
            items: itemList.map((T items) {
              return DropdownMenuItem(
                value: items,
                child:Text(itemView(items),style:  StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.black),),
              );
            }).toList(),
            hint: Text(hintText,style:selectItemStyle?? StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, valueSelectedOrNot==false?ColorResource.instance.textColor_2:ColorResource.instance.black),maxLines: 1,overflow: TextOverflow.ellipsis,textDirection: TextDirection.ltr,),
            borderRadius: BorderRadius.circular(10),
            underline: const SizedBox(),
            onChanged: ( newValue){
              onValueChanged(newValue as T);},
          ),
        )),
      );
    }
  }

  class DropdownButtonHelperWithSearch<T> extends StatelessWidget {
    final RxList<T> itemList;
    final bool valueSelectedOrNot;
    final Function(T value) onValueChanged;
    final String Function(T value) itemView;
    final String hintText;
    final bool? showBorder;
    final bool? isExpanded;
    final Color? bgColor;
    final Color? iconColor;
    final Color? borderColor;
    final double? height;
    final double? borderWidth;
    final TextStyle? selectItemStyle;
    final EdgeInsets? padding;


    const DropdownButtonHelperWithSearch({
      Key? key,
      required this.itemList,
      required this.onValueChanged,
      required this.itemView,
      required this.hintText,
      required this.valueSelectedOrNot,
      this.showBorder,
      this.bgColor,
      this.padding,
      this.isExpanded,
      this.selectItemStyle,
      this.iconColor,
      this.height,
      this.borderColor,
      this.borderWidth,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap:  () => _openSearchSheet(context),
        child: Container(
            height: height ?? 55,
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: bgColor ?? ColorResource.instance.white,
              border: Border.all(
                  color: showBorder == false
                      ? ColorResource.instance.transparent
                      : borderColor ?? ColorResource.instance.btnGreenColor,
                  width: borderWidth ?? .5),
            ),
            child: _buildSelectedView()

        ),
      );
    }



    /// selected view when search enabled
    Widget _buildSelectedView() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StyleResource.instance.styleRegular(
                DimensionResource.fontSizeDefault,
                valueSelectedOrNot
                    ? ColorResource.instance.black
                    : ColorResource.instance.textColor_2,
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: iconColor ?? ColorResource.instance.mainColor,
          ),
        ],
      );
    }



    /// SEARCH BOTTOM SHEET
    void _openSearchSheet(BuildContext context) {
      final RxList<T> filteredList = RxList<T>.from(itemList);
      final TextEditingController searchController = TextEditingController();

      Get.bottomSheet(
        Container(
          height: Get.height * .7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),

              /// search field
              Padding(
                padding: const EdgeInsets.all(12),
                child: CommonTextField(
                  controller: searchController,
                  outlineBorderColor: ColorResource.instance.btnBorderGreen.withValues(alpha: .4),
                  onValueChanged: (value) {
                    filteredList.value = itemList
                        .where((item) =>
                        itemView(item).toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  },
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                ),
              ),

              /// list
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (_, index) {
                    final item = filteredList[index];
                    return ListTile(
                      title: Text(itemView(item)),
                      onTap: () {
                        onValueChanged(item);
                        Get.back();
                      },
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      );
    }
  }

