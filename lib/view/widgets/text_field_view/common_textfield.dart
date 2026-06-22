import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';



// ignore: must_be_immutable
class CommonTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Function(String)? onFieldSubmitted;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final Color? outlineBorderColor;

  final EdgeInsetsGeometry? marginValue;
  final String? iconData;
  final bool? obscureText;
  final Widget? prefixIcon;
  final bool? readOnly;
  final bool? showShadow;
  final bool? autofocus;
  final bool? requiredFiled;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final Color? containerColor;
  final Color? cursorColor;
  final Color? outLineColor;
  final Color? hintColor;
  final Color? errorColor;
  final int? maxLength;
  final Widget? suffixIcon;
  final Function(String)? onValueChanged;
  final TextStyle? style;
  final TextStyle? hintStyle;
  RxInt textLength = 0.obs;
  final bool? enableFloatingLabel;
  final int? maxLines;
  final int? minLines;
  final double? height;



  final double? labelhintStyleHeight;
  CommonTextField(
      {super.key,
        this.validator,
        this.keyboardType,
        this.textInputAction,
        this.textCapitalization,
        this.onFieldSubmitted,
        this.initialValue,
        required this.hintText,
        this.errorText,
        this.showShadow,
        this.iconData,
        this.obscureText,
        this.prefixIcon,
        this.inputFormatters,
        required this.controller,
        this.containerColor,
        this.cursorColor,
        this.outLineColor,
        this.autofocus,
        this.hintColor,
        this.errorColor,
        this.maxLength,
        this.suffixIcon,
        this.onValueChanged,
        this.style,
        this.hintStyle,
        this.readOnly,
        this.labelhintStyleHeight,
        this.maxLines,
        this.minLines,
        this.enableFloatingLabel = false,
        this.marginValue,
        this.requiredFiled,
        this.height, this.outlineBorderColor,

      }) {
    textLength.value = controller.text.length;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height ?? 55,
          // color: ColorResource.instance.borderColor,
          margin: marginValue ??EdgeInsets.zero,
          child: TextFormField(

            controller: controller,
            maxLines: maxLines ?? 1,
            minLines: minLines ?? 1,
            readOnly: readOnly ?? false,
            inputFormatters: inputFormatters,
            autofocus: autofocus ?? false,
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardType: keyboardType,
            maxLength: maxLength,
            onChanged: (value) {
              textLength.value = value.length;
              try {
                onValueChanged!(value);
              } catch (_) {}
            },
            obscuringCharacter: '●',
            obscureText: obscureText??false,//This will obscure text dynamically
            cursorColor: ColorResource.instance.mainColor,
            style: style ?? StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.black),
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              filled: true,
                fillColor: containerColor??ColorResource.instance.white,
                prefixIcon: prefixIcon,
                counterText: '',
                floatingLabelAlignment: FloatingLabelAlignment.start,
                floatingLabelStyle :StyleResource.instance.styleRegular(DimensionResource.fontSizeExtraLargeWithOver, ColorResource.instance.hintStyleColor),
                label: enableFloatingLabel == true
                    ? RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: hintText,
                    style: StyleResource.instance
                        .styleRegular(DimensionResource.fontSizeDefault,
                        ColorResource.instance.hintStyleColor)
                        .copyWith(height: labelhintStyleHeight ?? 0),
                    children: <TextSpan>[
                      if (requiredFiled != false)
                        TextSpan(
                          text: '*',
                          style: style?.copyWith(
                              color: ColorResource.instance.hintStyleColor) ??
                              TextStyle(color: ColorResource.instance.mainColor),
                        ),
                    ],
                  ),
                ) : null,
                suffixIcon:  suffixIcon ?? Obx(() => textLength.value != 0 && readOnly!=true ? InkWell(
                  onTap: () {
                    textLength.value = 0;
                    controller.clear();
                    try {
                      onValueChanged!("");
                    } catch (_) {}
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: DimensionResource.marginSizeDefault, left: DimensionResource.marginSizeDefault),
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ColorResource.instance.black, width: 1)),
                    child: Icon(
                      Icons.clear,
                      color: ColorResource.instance.black,
                      size: 12,
                    ),
                  ),
                ) : const SizedBox()),
                hintText: hintText,
                // counterText: "",

                hintStyle: hintStyle ?? StyleResource.instance.styleRegular(DimensionResource.fontSizeDefault, ColorResource.instance.textColor_4).copyWith(height: 0),
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
                  borderSide: BorderSide(width: .5,color: outlineBorderColor ?? ColorResource.instance.borderColor),
                ),
                border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: .5,color:  ColorResource.instance.borderColor)
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
                errorText: errorText == null || errorText == "" ? null :'',
                errorStyle: const TextStyle(
                    height: 0,
                    fontSize: 0
                )
            ),
            validator: validator,
          ),
        ),
        errorText == null || errorText == ""
            ? const SizedBox()
            : Padding(
          padding: marginValue ?? EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(top: DimensionResource.marginSizeExtraSmall),
            child: Text(
              errorText ?? "",
              style: StyleResource.instance.styleRegular(
                  DimensionResource.fontSizeSmall,
                  ColorResource.instance.darkRedColor),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
    );
  }
}
