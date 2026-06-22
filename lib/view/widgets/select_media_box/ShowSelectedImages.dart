import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/file_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../cached_network_image_widget/cachednetworkimagewidget.dart';
import '../common/helper.dart';


class ShowSelectedMedia extends StatelessWidget {
  final List<SelectedMediaModel> mediaList;
  final bool ?showEditButton;
  const ShowSelectedMedia({Key? key, required this.mediaList,this.showEditButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 10,
      spacing: 10,
      children: List.generate(mediaList.length, (index) {
        SelectedMediaModel image = mediaList.elementAt(index);
        return SizedBox(
          width: 65,
          height: 65,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ColorResource.instance.mainColor, width: 2)),
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.video!
                        ? Image.memory(image.uint8list!)
                        : Image.file(
                      File(image.files!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: showEditButton??true,
                child: Positioned(
                    top: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        mediaList.removeAt(index);
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: ColorResource.instance.mainColor),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    )),
              ),
              image.video!
                  ? Align(
                alignment: Alignment.center,
                child: Image.asset(
                  ImageResource.instance.errorIcon,
                  height: 20,
                ),
              )
                  : const SizedBox()
            ],
          ),
        );
      }),
    );
  }
}

class ShowInstructionsMedia extends StatelessWidget {
  final List<String> mediaList;
  final bool ?showDownload;
  const ShowInstructionsMedia({Key? key, required this.mediaList, this.showDownload,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.start,
      runSpacing: 10,
      spacing: 10,
      children: List.generate(mediaList.length, (index) {
        return InkWell(
          // onTap: ()=>Get.to(ViewImageScreen(file: mediaList[index]),transition: Transition.cupertinoDialog),
          // onTap: ()=>UrlLaunch.instance.launchUrlFunction(path:mediaList[index],type:LunchUrl.lunch ),
          onTap: ()=> HelperFunction.onDownloadStatementDoc(mediaList[index],'Prescription'),
          child: Stack(
            children: [
              Container(
                padding:const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorResource.instance.secondMainColor, width: 1)),
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: mediaList[index],
                    key: Key(mediaList[index]),
                    child: p.extension(mediaList[index]) == ".jpeg" || p.extension(mediaList[index]) == ".png"|| p.extension(mediaList[index]) == ".jpg"?CachedNetworkImage(
                      imageUrl:mediaList[index],
                      fit:BoxFit.fill,
                    ) :CachedNetworkImage(
                      imageUrl:"https://cdn-icons-png.flaticon.com/512/6747/6747196.png",
                      fit:BoxFit.fill,
                    ).paddingAll(DimensionResource.marginSizeExtraSmall),
                  ),
                ),
              ),
              if(showDownload==true)
                Container(
                padding:const EdgeInsets.all(2),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: ColorResource.instance.black.withOpacity(.2)),
                width: 70,
                height: 70,
                
              ),
              if(showDownload==true)
                Positioned(bottom: 5,right: 5,child: Icon(Icons.download,size: 20,color: ColorResource.instance.white,)),
            ],
          ),
        );
      }),
    );
  }
}

class ViewImageScreen extends StatelessWidget {
  final String file;
  TransformationController ?transformationController;
  RxInt quarterTurns=4.obs;
  TapDownDetails? doubleTapDetails;
  ViewImageScreen({super.key,required this.file}){
  transformationController=TransformationController();
  }
  @override
  Widget build(BuildContext context) {
    void handleDoubleTapDown(TapDownDetails details) {
      doubleTapDetails = details;
    }
    void handleDoubleTap() {
      if (transformationController?.value != Matrix4.identity()) {
        transformationController?.value = Matrix4.identity();
      } else {
        final position = doubleTapDetails!.localPosition;
        transformationController?.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(()=>RotatedBox(
            quarterTurns: quarterTurns.value,
            child: Hero(
              tag: file,
              key: Key(file),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GestureDetector(
                  onDoubleTapDown: handleDoubleTapDown,
                  onDoubleTap: handleDoubleTap,
                  child: InteractiveViewer(
                    transformationController: transformationController,
                    child: CachedNetworkImageWidget(imageUrl: file, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          )),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 5,
              child: IconButton(
                  onPressed: () {
                    if(quarterTurns.value==4){
                      quarterTurns.value=1;
                    }else{
                      quarterTurns.value=4;
                    }
                  },
                  icon:const Icon(
                    Icons.rotate_left_outlined,
                    color: Colors.white,
                    size: 30,
                  ))),
          Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 5,
              child: IconButton(onPressed: ()=>Get.back(),icon: Icon(Icons.arrow_back_ios,color: ColorResource.instance.white,),)),
        ],
      ),
    );
  }
}

