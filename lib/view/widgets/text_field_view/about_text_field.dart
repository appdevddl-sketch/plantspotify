import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';




class AboutUsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String ?hintText;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  const AboutUsTextField({Key? key,required this.controller, this.hintText, this.validator, this.errorText,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          decoration:BoxDecoration(
              color:  ColorResource.instance.white,
              border: Border(
                  bottom: BorderSide(color: ColorResource.instance.lightMainColor, width: 1.5)
              )),
          child: TextFormField(
            controller: controller,
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            cursorColor: ColorResource.instance.mainColor,
            // inputFormatters: [
            //   LengthLimitingTextInputFormatter(200),
            // ],
            style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.black),
            decoration: InputDecoration(
                alignLabelWithHint: true,
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelStyle :StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraLargeWithOver, ColorResource.instance.hintStyleColor),
                hintText: hintText,
                label: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: hintText,
                    style: StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.hintStyleColor),
                  ),
                ),
                hintStyle:  StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_4),
                errorText: errorText == null || errorText == "" ? null :'',
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(width: .5,color: ColorResource.instance.secondMainColor),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius:const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(width: .5,color: ColorResource.instance.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(width: .5,color: ColorResource.instance.borderColor),
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: .5,color: ColorResource.instance.borderColor)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: .5,color: ColorResource.instance.darkRedColor)
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: .5,color: ColorResource.instance.darkRedColor)
                ),
                contentPadding: const EdgeInsets.only(
                  left: DimensionResource.marginSizeDefault,
                  bottom: DimensionResource.marginSizeDefault+2,
                  top:DimensionResource.marginSizeDefault+2,
                  right: DimensionResource.marginSizeDefault,
                ),
                errorStyle: const TextStyle(
                  height: 0,
                )),
            validator: validator,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Visibility(
                  visible: errorText == null || errorText == "" ? false : true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                    child: Text(
                      errorText??"",
                      style: StyleResource.instance.styleRegular(
                          DimensionResource.fontSizeSmall,
                          ColorResource.instance.darkRedColor),
                      textAlign: TextAlign.start,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: Text("Maximum 200 characters.".tr,
                  style: StyleResource.instance.styleRegular(DimensionResource.fontSizeSmall, ColorResource.instance.hintStyleColor)),
            ),
          ],
        ),
      ],
    );
  }
}